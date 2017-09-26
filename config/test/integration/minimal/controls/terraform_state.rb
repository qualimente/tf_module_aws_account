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

    describe'configuration recorder' do
      config_recorder = resources['aws_config_configuration_recorder.config']['primary']
      config_recorder_attributes = config_recorder['attributes']

      describe('set the name of the configuration recorder') do
        subject { config_recorder_attributes['name'] }
        it { is_expected.to eq("minimal-config_recorder") }
      end
    end
  end
end
