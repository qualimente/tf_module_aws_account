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
    describe 'outputs' do

      describe('cloudtrail.id') do
        subject { outputs['cloudtrail.id'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "minimal"}) }
      end
      describe('cloudtrail.home_region') do
        subject { outputs['cloudtrail.home_region'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "us-west-2"}) }
      end

      describe('cloudtrail.arn') do
        subject { outputs['cloudtrail.arn']['value'] }
        it { is_expected.to match(/arn:aws:cloudtrail:[\w-]+:[\d]+:trail\/minimal/) }
      end
      describe('cloudtrail.cloudwatch_log_group_arn') do
        subject { outputs['cloudtrail.cloudwatch_log_group_arn']['value'] }
        it { is_expected.to match(/arn:aws:logs:[\w-]+:[\d]+:log-group:\/aws\/cloudtrail\/minimal:\*/) }
      end

      describe('cloudtrail.iam_role_name') do
        subject { outputs['cloudtrail.iam_role_name'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "minimal-CloudTrailToCloudWatch"}) }
      end
      describe('cloudtrail.iam_role_arn') do
        subject { outputs['cloudtrail.iam_role_arn']['value'] }
        it { is_expected.to match(/arn:aws:iam::[\d]+:role\/minimal-CloudTrailToCloudWatch/) }
      end

      describe('cloudtrail.s3_bucket_id') do
        subject { outputs['cloudtrail.s3_bucket_id']['value'] }
        it { is_expected.to match(/^qm-test-cloudtrail-logs-[\w]+/)}
      end
      describe('cloudtrail.s3_bucket_arn') do
        subject { outputs['cloudtrail.s3_bucket_arn']['value'] }
        it { is_expected.to match(/^arn:aws:s3:::qm-test-cloudtrail-logs-[\w]+/)}
      end

    end

  end

end