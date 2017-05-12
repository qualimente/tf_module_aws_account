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

      describe('aws_account.id') do
        subject { outputs['aws_account.id'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "minimal"}) }
      end

      describe('aws_account.home_region') do
        subject { outputs['aws_account.home_region'] }
        it { is_expected.to eq({"sensitive" => false, "type" => "string", "value" => "us-west-2"}) }
      end

    end

  end

end
