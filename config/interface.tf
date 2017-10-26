//Setup default config variables
variable "aws_config_name" {
  description = "Name for AWS config resources"
  type        = "string"
}

variable "s3_bucket_name" {
  description = "Name for AWS config bucket"
  type        = "string"
}

// Outputs
output "config.config_recorder_arn" {
  value = "${aws_config_configuration_recorder.config.arn}"
}

output "config.s3_bucket_id" {
  value = "${aws_s3_bucket.config.id}"
}

output "config.s3_bucket_arn" {
  value = "${aws_s3_bucket.config.arn}"
}

output "config.iam_role_name" {
  value = "${aws_iam_role.config.name}"
}

output "congig.iam_role_arn" {
  value = "${aws_iam_role.config.arn}"
}
