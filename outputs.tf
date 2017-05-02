// Outputs
output "cloudtrail_id" {
  value = "${aws_cloudtrail.ct.id}"
}

output "cloudtrail_home_region" {
  value = "${aws_cloudtrail.ct.home_region}"
}

output "cloudtrail_arn" {
  value = "${aws_cloudtrail.ct.arn}"
}

output "iam_role_cloudtrail_name" {
  value = "${aws_iam_role.ct.name}"
}

output "iam_role_cloudtrail_arn" {
  value = "${aws_iam_role.ct.arn}"
}

output "cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.ct.arn}"
}

output "s3_bucket_id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}
