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
    policy = resources['aws_iam_account_password_policy.account_password_policy']['primary']
    describe 'policy' do

      describe('id') do
        subject { policy['id'] }
        it { is_expected.to eq("iam-account-password-policy") }
      end

      attributes = policy['attributes']
      describe 'policy attributes' do

        describe('allow users to change password') do
          subject { attributes['allow_users_to_change_password'] }
          it { is_expected.to eq("true") }
        end

        describe('expire passwords') do
          subject { attributes['expire_passwords'] }
          it { is_expected.to eq("true") }
        end

        describe('hard expiration for password') do
          subject { attributes['hard_expiry'] }
          it { is_expected.to eq("false") }
        end

        describe('maximum password age in days') do
          subject { attributes['max_password_age'] }
          it { is_expected.to eq("90") }
        end

        describe('minimum length for password') do
          subject { attributes['minimum_password_length'] }
          it { is_expected.to eq("12") }
        end

        describe('password reuse check for how many previous passwords') do
          subject { attributes['password_reuse_prevention'] }
          it { is_expected.to eq("12") }
        end

        describe('require lowercase characters in password') do
          subject { attributes['require_lowercase_characters'] }
          it { is_expected.to eq("true") }
        end

        describe('require numbers in password') do
          subject { attributes['require_numbers'] }
          it { is_expected.to eq("true") }
        end

        describe('require symbols in password') do
          subject { attributes['require_symbols'] }
          it { is_expected.to eq("false") }
        end

        describe('require uppercase characters in password') do
          subject { attributes['require_uppercase_characters'] }
          it { is_expected.to eq("true") }
        end

      end

    end

  end

end
