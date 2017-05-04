// Outputs
output "cloudtrail.id" {
  value = "${aws_cloudtrail.ct.id}"
}

output "cloudtrail.home_region" {
  value = "${aws_cloudtrail.ct.home_region}"
}

output "cloudtrail.arn" {
  value = "${aws_cloudtrail.ct.arn}"
}

output "cloudtrail.iam_role_name" {
  value = "${aws_iam_role.ct.name}"
}

output "cloudtrail.iam_role_arn" {
  value = "${aws_iam_role.ct.arn}"
}

output "cloudtrail.cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.ct.arn}"
}

output "cloudtrail.s3_bucket_id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "cloudtrail.s3_bucket_arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}
