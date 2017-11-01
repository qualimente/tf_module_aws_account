require 'json'
require 'rspec/expectations'


terraform_state = attribute 'terraform_state', {}

control 'terraform_state' do
  tf_state_json = json(terraform_state)

  describe 'the Terraform state file' do
    subject { json(terraform_state).terraform_version }

    it('is accessible') { is_expected.to match(/\d+\.\d+\.\d+/) }
  end

  describe 'the Terraform state file' do
    #require 'pry'; binding.pry; #uncomment to jump into the debugger

    outputs = tf_state_json.modules[1]['outputs']
    
    describe('config.config_recorder_id') do
      subject { outputs['config.config_recorder_id']['value'] }
      it { is_expected.to match(/test-[\w]+/) }
    end

    describe('config.iam_role_name') do
      subject { outputs['config.iam_role_name']['value'] }
      it { is_expected.to match(/AR-Config-[\w]+/) }
    end
    describe('config.iam_role_arn') do
      subject { outputs['config.iam_role_arn']['value'] }
      it { is_expected.to match(/arn:aws:iam::[\d]+:role\/AR-Config-[\w]+/) }
    end

    describe('config.s3_bucket_id') do
      subject { outputs['config.s3_bucket_id']['value'] }
      it { is_expected.to match(/^qm-infra-module-config-test-[\w]+/)}
    end
    describe('config.s3_bucket_arn') do
      subject { outputs['config.s3_bucket_arn']['value'] }
      it { is_expected.to match(/^arn:aws:s3:::qm-infra-module-config-test-[\w]+/)}
    end
    

    resources = tf_state_json.modules[1]['resources']
    describe 'configuration recorder' do
      config_recorder = resources['aws_config_configuration_recorder.config']['primary']
      config_recorder_attributes = config_recorder['attributes']

      describe('set the name of the configuration recorder') do
        subject { config_recorder_attributes['name'] }
        it { is_expected.to match(/test-[\w]+/) }
      end
    end

    describe 'aws managed config rules' do

      [
          'IAM_PASSWORD_POLICY',
          'S3_BUCKET_LOGGING_ENABLED',
          'S3_BUCKET_PUBLIC_READ_PROHIBITED',
          'S3_BUCKET_PUBLIC_WRITE_PROHIBITED',
          'S3_BUCKET_SSL_REQUESTS_ONLY',
          'S3_BUCKET_VERSIONING_ENABLED',
          'ACM_CERTIFICATE_EXPIRATION_CHECK',
          'IAM_USER_GROUP_MEMBERSHIP_CHECK',
          'IAM_USER_NO_POLICIES_CHECK',
          'ROOT_ACCOUNT_MFA_ENABLED',
          'CLOUD_TRAIL_ENABLED',
          'INSTANCES_IN_VPC',
          'CLOUDFORMATION_STACK_NOTIFICATION_CHECK',
      ].each do |rule_name|
        rule = resources["aws_config_config_rule.#{rule_name}"]['primary']
        rule_attributes = rule['attributes']

        describe("#{rule_name} rule") do
          describe("name") do
            subject { rule_attributes['name'] }
            it { is_expected.to match(/#{Regexp.quote(rule_name)}-test-[\w]+/) }
          end
          describe("arn") do
            subject { rule_attributes['arn'] }
            it { is_expected.to match(/arn:aws:config:[\w-]+:[\d]+:config-rule\/config-rule-[\w]+/) }
          end
        end
      end
    end
  end
end
