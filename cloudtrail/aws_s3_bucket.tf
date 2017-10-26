// AWS CloudTrail S3 Bucket
data "template_file" "aws_s3_bucket_policy" {
  template = "${file("${path.module}/aws_s3_bucket_policy.tpl")}"

  vars {
    aws_account_id = "${var.aws_account_id}"
    s3_bucket_arn  = "${aws_s3_bucket.bucket.arn}"
  }
}

resource "aws_s3_bucket" "bucket" {
  # keep things consistrent & prevent conflicts across envs.
  bucket = "${var.s3_bucket_name}${var.s3_bucket_suffix}"
  acl    = "private"

  versioning = {
    enabled = "false"
  }

  force_destroy = "${var.s3_force_destroy}"

  tags = {
    terraform = "true"
  }

  // https://github.com/hashicorp/terraform/issues/13631
  // There is a race condition between creation of IAM/S3 resources and when they are visible to Cloudtrail
  // sleep a bit during IAM role creation to enable the change to propagate at AWS
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${data.template_file.aws_s3_bucket_policy.rendered}"
}
