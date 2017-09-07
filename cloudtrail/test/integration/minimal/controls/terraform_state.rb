require 'json'
require 'rspec/expectations'


terraform_state = attribute 'terraform_state', {}

expect_bucket_name = "qm-infra-module-ct-logs-2017-09-07"

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
        subject { outputs['cloudtrail.arn'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "arn:aws:cloudtrail:us-west-2:139710491120:trail/minimal"}) }
      end
      describe('cloudtrail.cloudwatch_log_group_arn') do
        subject { outputs['cloudtrail.cloudwatch_log_group_arn'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => 'arn:aws:logs:us-west-2:139710491120:log-group:/aws/cloudtrail/minimal:*'}) }
      end

      describe('cloudtrail.iam_role_name') do
        subject { outputs['cloudtrail.iam_role_name'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "minimal-CloudTrailToCloudWatch"}) }
      end
      describe('cloudtrail.iam_role_arn') do
        subject { outputs['cloudtrail.iam_role_arn'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "arn:aws:iam::139710491120:role/minimal-CloudTrailToCloudWatch"}) }
      end

      describe('cloudtrail.s3_bucket_id') do
        subject { outputs['cloudtrail.s3_bucket_id'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => expect_bucket_name}) }
      end
      describe('cloudtrail.s3_bucket_arn') do
        subject { outputs['cloudtrail.s3_bucket_arn'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "arn:aws:s3:::#{expect_bucket_name}"}) }
      end

    end

  end

end