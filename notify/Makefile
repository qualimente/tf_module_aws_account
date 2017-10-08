.PHONY: bash format converge verify destroy test kitchen
TERRAFORM_SPEC_VERSION := 0.9.11

AWS_AUTH_VARS :=

ifdef AWS_PROFILE
	AWS_AUTH_VARS := $(AWS_AUTH_VARS) -e "AWS_PROFILE=$(AWS_PROFILE)"
endif

ifdef AWS_ACCESS_KEY_ID
	AWS_AUTH_VARS := $(AWS_AUTH_VARS) -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)"
endif

ifdef AWS_SECRET_ACCESS_KEY
	AWS_AUTH_VARS := $(AWS_AUTH_VARS) -e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)"
endif

ifdef AWS_SESSION_TOKEN
	AWS_AUTH_VARS := $(AWS_AUTH_VARS) -e "AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN)"
endif

define execute
	if [ -z "$(CI)" ]; then \
		docker run --rm -it \
			-e AWS_REGION=$(AWS_REGION) \
			$(AWS_AUTH_VARS) \
			-e USER=root \
			-v $(shell pwd):/module \
			-v $(HOME)/.aws:/root/.aws:ro \
			qualimente/terraform-spec:$(TERRAFORM_SPEC_VERSION) \
			kitchen $(1) $(KITCHEN_OPTS); \
	else \
		echo bundle exec kitchen $(1) $(KITCHEN_OPTS); \
		bundle exec kitchen $(1) $(KITCHEN_OPTS); \
	fi;
endef

format:
	@docker run --rm -it \
		-v $(shell pwd):/module \
		qualimente/terraform-spec:$(TERRAFORM_SPEC_VERSION) \
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

bash:
	@docker run --rm -it \
		-e AWS_REGION=$(AWS_REGION) \
		$(AWS_AUTH_VARS) \
		-e USER=root \
		-v $(shell pwd):/module \
		-v $(HOME)/.aws:/root/.aws:ro \
		qualimente/terraform-spec:$(TERRAFORM_SPEC_VERSION) \
		bash
