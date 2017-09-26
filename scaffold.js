#! /usr/local/Cellar/node/7.10.0/bin/node

const fs = require('fs');
const path = require('path');

console.log(process.argv)
if (process.argv[2]) {
  var awsService = process.argv[2];
} else {
  console.log(`
    USAGE:
    scaffold [AWS Service Name]`,
    new Error('You must specify an AWS service to scaffold.'));
  process.exit(1);
}

const kitchenYmlText =
`---
driver:
name: terraform

platforms:
- name: aws

suites:
- name: minimal
  provisioner:
    name: terraform
    apply_timeout: 600
    color: true
    directory: >-
      test/fixtures/minimal
    variables:
      user: <%= ENV['USER'] %>
  verifier:
    name: terraform
    format: doc
    groups:
      - name: terraform
        controls:
          - terraform_state
`;

const inspecYmlText =
`---
name: minimal`

const makeFileText =
`.PHONY: format converge verify destroy test kitchen
TERRAFORM_SPEC_VERSION := 0.9.11

define execute
	if [ -z "$(CI)" ]; then \\
		docker run --rm -it \\
			-e AWS_PROFILE=$(AWS_PROFILE) \\
			-e AWS_REGION=$(AWS_REGION) \\
			-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \\
			-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \\
			-e USER=$(USER) \\
			-v $(shell pwd):/module \\
			-v $(HOME)/.aws:/root/.aws:ro \\
			-v $(HOME)/.netrc:/root/.netrc:ro \\
			qualimente/terraform-spec:$(TERRAFORM_SPEC_VERSION) \\
			kitchen $(1) $(KITCHEN_OPTS); \\
	else \\
		echo bundle exec kitchen $(1) $(KITCHEN_OPTS); \\
		bundle exec kitchen $(1) $(KITCHEN_OPTS); \\
	fi;
endef

format:
	@docker run --rm -it \\
		-v $(shell pwd):/module \\
		qualimente/terraform-spec:$(TERRAFORM_SPEC_VERSION) \\
		terraform fmt

converge:
	@$(call execute,converge)

verify:
	@$(call execute,verify)

destroy:
	@$(call execute,destroy)

test:
	@$(call execute,test)

kitchen:
	@$(call execute,$(COMMAND))
`;

const minimalTfText =
`// instantiate the ${awsService.toLowerCase()} module only supplying required parameters with the intent of really exercising the defaults

module "it_minimal" {
  source = "../../../" //minimal integration test

}
`;

const terraform_stateText =
`require 'json'
require 'rspec/expectations'


terraform_state = attribute 'terraform_state', {}
`;

const outputsText = '// Outputs';
const tfResourceText = `// Provide ${awsService.toLowerCase()} resource here`;
const variablesText = `//Setup default ${awsService.toLowerCase()} variables`;

const scaffoldDirectory = () => {
  fs.mkdirSync(`./${awsService.toLowerCase()}`);
  fs.mkdirSync(`./${awsService.toLowerCase()}/test`);
  fs.mkdirSync(`./${awsService.toLowerCase()}/test/fixtures`);
  fs.mkdirSync(`./${awsService.toLowerCase()}/test/fixtures/minimal`);
  fs.mkdirSync(`./${awsService.toLowerCase()}/test/integration`);
  fs.mkdirSync(`./${awsService.toLowerCase()}/test/integration/minimal`);
  fs.mkdirSync(`./${awsService.toLowerCase()}/test/integration/minimal/controls`);
};

const writeFileCallback = (error) => {
  if (error) {
    throw error;
  }
};

const scaffoldFiles = () => {
  fs.writeFile(`./${awsService.toLowerCase()}/.kitchen.yml`, kitchenYmlText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/Makefile`, makeFileText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/${awsService.toLowerCase()}.tf`, tfResourceText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/outputs.tf`, outputsText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/variables.tf`, variablesText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/test/fixtures/minimal/minimal.tf`, minimalTfText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/test/integration/minimal/inspec.yml`, inspecYmlText, writeFileCallback);
  fs.writeFile(`./${awsService.toLowerCase()}/test/integration/minimal/controls/terraform_state.rb`, terraform_stateText, writeFileCallback);
};

scaffoldDirectory();
scaffoldFiles();
console.log(awsService);
