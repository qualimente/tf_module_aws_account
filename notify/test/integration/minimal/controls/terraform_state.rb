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

      describe('notify.billing_notification_https_subscription_arn') do
        subject { outputs['notify.billing_notification_https_subscription_arn']['value'] }
        it { is_expected.to match(/^arn:aws:sns:us-east-1:[\d]+:[\w-]+/)}
      end

    end

  end

end