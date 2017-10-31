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
      describe 'IAM_PASSWORD_POLICY' do
        aws_config_IAM_PASSWORD_POLICY_rule = resources['aws_config_config_rule.IAM_PASSWORD_POLICY']['primary']
        aws_config_IAM_PASSWORD_POLICY_rule_attributes = aws_config_IAM_PASSWORD_POLICY_rule['attributes']

        describe('set the name of the rule') do
          subject { aws_config_IAM_PASSWORD_POLICY_rule_attributes['name'] }
          it { is_expected.to match(/IAM_PASSWORD_POLICY-test-[\w]+/) }
        end
      end

      describe 'S3_BUCKET_LOGGING_ENABLED' do
        aws_config_S3_BUCKET_LOGGING_ENABLED_rule = resources['aws_config_config_rule.S3_BUCKET_LOGGING_ENABLED']['primary']
        aws_config_S3_BUCKET_LOGGING_ENABLED_rule_attributes = aws_config_S3_BUCKET_LOGGING_ENABLED_rule['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_LOGGING_ENABLED_rule_attributes['name'] }
          it { is_expected.to match(/S3_BUCKET_LOGGING_ENABLED-test-[\w]+/) }
        end
      end

      describe 'S3_BUCKET_PUBLIC_READ_PROHIBITED' do
        aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule = resources['aws_config_config_rule.S3_BUCKET_PUBLIC_READ_PROHIBITED']['primary']
        aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule_attributes = aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_PUBLIC_READ_PROHIBITED_rule_attributes['name'] }
          it { is_expected.to match(/S3_BUCKET_PUBLIC_READ_PROHIBITED-test-[\w]+/) }
        end
      end

      describe 'S3_BUCKET_PUBLIC_WRITE_PROHIBITED' do
        aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule = resources['aws_config_config_rule.S3_BUCKET_PUBLIC_WRITE_PROHIBITED']['primary']
        aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule_attributes = aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_PUBLIC_WRITE_PROHIBITED_rule_attributes['name'] }
          it { is_expected.to match(/S3_BUCKET_PUBLIC_WRITE_PROHIBITED-test-[\w]+/) }
        end
      end

      describe 'S3_BUCKET_SSL_REQUESTS_ONLY' do
        aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule = resources['aws_config_config_rule.S3_BUCKET_SSL_REQUESTS_ONLY']['primary']
        aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule_attributes = aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_SSL_REQUESTS_ONLY_rule_attributes['name'] }
          it { is_expected.to match(/S3_BUCKET_SSL_REQUESTS_ONLY-test-[\w]+/) }
        end
      end

      describe 'S3_BUCKET_VERSIONING_ENABLED' do
        aws_config_S3_BUCKET_VERSIONING_ENABLED_rule = resources['aws_config_config_rule.S3_BUCKET_VERSIONING_ENABLED']['primary']
        aws_config_S3_BUCKET_VERSIONING_ENABLED_rule_attributes = aws_config_S3_BUCKET_VERSIONING_ENABLED_rule['attributes']

        describe('set the name of the rule') do
          subject { aws_config_S3_BUCKET_VERSIONING_ENABLED_rule_attributes['name'] }
          it { is_expected.to match(/S3_BUCKET_VERSIONING_ENABLED-test-[\w]+/) }
        end
      end

      describe 'ACM_CERTIFICATE_EXPIRATION_CHECK' do
        aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule = resources['aws_config_config_rule.ACM_CERTIFICATE_EXPIRATION_CHECK']['primary']
        aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule_attributes = aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule['attributes']
        puts aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule_attributes
        describe('set the name of the rule') do
          subject { aws_config_ACM_CERTIFICATE_EXPIRATION_CHECK_rule_attributes['name'] }
          it { is_expected.to match(/ACM_CERTIFICATE_EXPIRATION_CHECK-test-[\w]+/) }
        end
      end
    end
  end
end
