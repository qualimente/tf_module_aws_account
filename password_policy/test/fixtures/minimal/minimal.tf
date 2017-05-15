// instantiate the cloudtrail module only supplying required parameters with the intent of really exercising the defaults

module "it_minimal" {
  source = "../../../" //minimal integration test

  aws_password_minimum_length       = "12"
  aws_password_require_lowercase    = true
  aws_password_require_numbers      = true
  aws_password_require_uppercase    = true
  aws_password_require_symbols      = false
  aws_password_max_age              = "90"
  aws_password_reuse                = "12"
  aws_password_allow_change_by_user = true
  aws_password_expiration_lock      = false
}
