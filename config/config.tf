// Provide config resource here
data "template_file" "aws_iam_config_assume_role_policy" {
  template = "${file("${path.module}/aws_iam_config_assume_role_policy.tpl")}"
}

data "template_file" "aws_iam_config_policy" {
  template = "${file("${path.module}/aws_iam_config_policy.tpl")}"
}

data "template_file" "aws_s3_config_bucket_policy" {
  template = "${file("${path.module}/aws_s3_config_bucket_policy.tpl")}"

  vars {
    s3_bucket_arn = "${aws_s3_bucket.config.arn}"
  }
}

resource "aws_config_configuration_recorder" "config" {
  name     = "${var.aws_config_name}"
  role_arn = "${aws_iam_role.config.arn}"
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = "${aws_config_configuration_recorder.config.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.config"]
}

resource "aws_config_delivery_channel" "config" {
  name           = "${var.aws_config_name}"
  s3_bucket_name = "${aws_s3_bucket.config.bucket}"
}

resource "aws_config_config_rule" "IAM_PASSWORD_POLICY" {
  name = "IAM_PASSWORD_POLICY-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_LOGGING_ENABLED" {
  name = "S3_BUCKET_LOGGING_ENABLED-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LOGGING_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_PUBLIC_READ_PROHIBITED" {
  name = "S3_BUCKET_PUBLIC_READ_PROHIBITED-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_PUBLIC_WRITE_PROHIBITED" {
  name = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_SSL_REQUESTS_ONLY" {
  name = "S3_BUCKET_SSL_REQUESTS_ONLY-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_VERSIONING_ENABLED" {
  name = "S3_BUCKET_VERSIONING_ENABLED-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "ACM_CERTIFICATE_EXPIRATION_CHECK" {
  name = "ACM_CERTIFICATE_EXPIRATION_CHECK-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "ACM_CERTIFICATE_EXPIRATION_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "IAM_USER_GROUP_MEMBERSHIP_CHECK" {
  name = "IAM_USER_GROUP_CHECK-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_GROUP_MEMBERSHIP_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "IAM_USER_NO_POLICIES_CHECK" {
  name = "IAM_USER_NO_POLICIES_CHECK-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_POLICIES_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "ROOT_ACCOUNT_MFA_ENABLED" {
  name = "ROOT_ACCOUNT_MFA_ENABLED-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "CLOUD_TRAIL_ENABLED" {
  name = "CLOUD_TRAIL_ENABLED-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "INSTANCES_IN_VPC" {
  name = "INSTANCES_IN_VPC-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "INSTANCES_IN_VPC"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "CLOUDFORMATION_STACK_NOTIFICATION_CHECK" {
  name = "CLOUDFORMATION_CHECK-${var.aws_config_name}"

  source {
    owner             = "AWS"
    source_identifier = "CLOUDFORMATION_STACK_NOTIFICATION_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_iam_role" "config" {
  name               = "AR-Config-${var.aws_config_name}"
  assume_role_policy = "${data.template_file.aws_iam_config_assume_role_policy.rendered}"
}

resource "aws_iam_policy" "config" {
  name   = "Config-${var.aws_config_name}"
  policy = "${data.template_file.aws_iam_config_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = "${aws_iam_role.config.name}"
  policy_arn = "${aws_iam_policy.config.arn}"
}

resource "aws_s3_bucket" "config" {
  bucket        = "${var.s3_bucket_name}-config"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "config" {
  bucket = "${aws_s3_bucket.config.id}"
  policy = "${data.template_file.aws_s3_config_bucket_policy.rendered}"
}
