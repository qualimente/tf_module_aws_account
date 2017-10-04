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

    resources = tf_state_json.modules[1]['resources']

    describe 'configuration recorder' do
      config_recorder = resources['aws_config_configuration_recorder.config']['primary']
      config_recorder_attributes = config_recorder['attributes']

      describe('set the name of the configuration recorder') do
        subject { config_recorder_attributes['name'] }
        it { is_expected.to eq("testing-gjullianfk-config_recorder") }
      end
    end

    describe 'aws managed config rules' do
      describe 'IAM_PASSWORD_POLICY' do
        aws_config_IAM_PASSWORD_POLICY_rule = ['aws_config_config_rule.IAM_PASSWORD_POLICY']['primary']
        aws_config_IAM_PASSWORD_POLICY_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_IAM_PASSWORD_POLICY_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_IAM_PASSWORD_POLICY") }
        end
      end

      describe 'S3_BUCKET_LOGGING_ENABLED' do
        aws_config_S3_BUCKET_LOGGING_ENABLED_rule = ['aws_config_config_rule.S3_BUCKET_LOGGING_ENABLED']['primary']
        aws_config_IAM_PASSWORD_POLICY_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_LOGGING_ENABLED_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_S3_BUCKET_LOGGING_ENABLED") }
        end
      end

      describe 'S3_BUCKET_PUBLIC_READ_PROHIBITED' do
        aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule = ['aws_config_config_rule.S3_BUCKET_PUBLIC_READ_PROHIBITED']['primary']
        aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_S3_BUCKET_PUBLIC_READ_PROHIBITED") }
        end
      end

      describe 'S3_BUCKET_PUBLIC_WRITE_PROHIBITED' do
        aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule = ['aws_config_config_rule.S3_BUCKET_PUBLIC_WRITE_PROHIBITED']['primary']
        aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_S3_BUCKET_PUBLIC_WRITE_PROHIBITED") }
        end
      end

      describe 'S3_BUCKET_SSL_REQUESTS_ONLY' do
        aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule = ['aws_config_config_rule.S3_BUCKET_SSL_REQUESTS_ONLY']['primary']
        aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_S3_BUCKET_SSL_REQUESTS_ONLY") }
        end
      end

      describe 'S3_BUCKET_VERSIONING_ENABLED' do
        aws_config_S3_BUCKET_VERSIONING_ENABLED_rule = ['aws_config_config_rule.S3_BUCKET_VERSIONING_ENABLED']['primary']
        aws_config_S3_BUCKET_VERSIONING_ENABLED_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_VERSIONING_ENABLED_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_S3_BUCKET_VERSIONING_ENABLED") }
        end
      end

      describe 'ACM_CERTIFICATE_EXPIRATION_CHECK' do
        aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule = ['aws_config_config_rule.ACM_CERTIFICATE_EXPIRATION_CHECK']['primary']
        aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule_attributes = ['attributes']

        describe('set the name of the rule') do
          subject { aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule_attributes['name'] }
          it { is_expected.to eq("testing-gjullianfk-config_rule_ACM_CERTIFICATE_EXPIRATION_CHECK") }
        end
      end

    end
  end
end
