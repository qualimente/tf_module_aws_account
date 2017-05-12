/**
 * Provides chosen password policy on AWS Accounts.
 */

resource "aws_iam_account_password_policy" "account_password_policy" {
  minimum_password_length        = "${var.aws_password_minimum_length}"
  require_lowercase_characters   = "${var.aws_password_require_lowercase}"
  require_numbers                = "${var.aws_password_require_numbers}"
  require_uppercase_characters   = "${var.aws_password_require_uppercase}"
  require_symbols                = "${var.aws_password_require_symbols}"
  max_password_age               = "${var.aws_password_max_age}"
  password_reuse_prevention      = "${var.aws_password_reuse}"
  allow_users_to_change_password = "${var.aws_password_allow_change_by_user}"
  hard_expiry                    = "${var.aws_password_expiration_lock}"
}
