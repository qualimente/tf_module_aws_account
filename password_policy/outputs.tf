// Outputs

// aws_iam_account_password_policy does not export anything worthwhile
output "aws_account.id" {
  value = "${aws_account_id}"
}

output "aws_account.home_region" {
  value = "${aws_region}"
}
