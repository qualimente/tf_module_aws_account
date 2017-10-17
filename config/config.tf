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
  name     = "${var.aws_config_name}-config_recorder"
  role_arn = "${aws_iam_role.config.arn}"
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = "${aws_config_configuration_recorder.config.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.config"]
}

resource "aws_config_delivery_channel" "config" {
  name           = "${var.aws_config_name}-config_delivery_channel"
  s3_bucket_name = "${aws_s3_bucket.config.bucket}"
}

resource "aws_config_config_rule" "IAM_PASSWORD_POLICY" {
  name = "${var.aws_config_name}-config_rule_IAM_PASSWORD_POLICY"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_LOGGING_ENABLED" {
  name = "${var.aws_config_name}-config_rule_S3_BUCKET_LOGGING_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LOGGING_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_PUBLIC_READ_PROHIBITED" {
  name = "${var.aws_config_name}-config_rule_S3_BUCKET_PUBLIC_READ_PROHIBITED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_PUBLIC_WRITE_PROHIBITED" {
  name = "${var.aws_config_name}-config_rule_S3_BUCKET_PUBLIC_WRITE_PROHIBITED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_SSL_REQUESTS_ONLY" {
  name = "${var.aws_config_name}-config_rule_S3_BUCKET_SSL_REQUESTS_ONLY"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "S3_BUCKET_VERSIONING_ENABLED" {
  name = "${var.aws_config_name}-config_rule_S3_BUCKET_VERSIONING_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "ACM_CERTIFICATE_EXPIRATION_CHECK" {
  name = "${var.aws_config_name}-config_rule_S3_ACM_CERT_CHECK"

  source {
    owner             = "AWS"
    source_identifier = "ACM_CERTIFICATE_EXPIRATION_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "IAM_USER_GROUP_MEMBERSHIP_CHECK" {
  name = "${var.aws_config_name}-config_rule_S3_IAM_USER_GROUP_CHECK"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_GROUP_MEMBERSHIP_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "IAM_USER_NO_POLICIES_CHECK" {
  name = "${var.aws_config_name}-config_rule_S3_IAM_USER_NO_POLICIES_CHECK"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_POLICIES_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "ROOT_ACCOUNT_MFA_ENABLED" {
  name = "${var.aws_config_name}-config_rule_S3_ROOT_ACCOUNT_MFA_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "CLOUD_TRAIL_ENABLED" {
  name = "${var.aws_config_name}-config_rule_CLOUD_TRAIL_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "INSTANCES_IN_VPC" {
  name = "${var.aws_config_name}-config_rule_S3_INSTANCES_IN_VPC"

  source {
    owner             = "AWS"
    source_identifier = "INSTANCES_IN_VPC"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_config_rule" "CLOUDFORMATION_STACK_NOTIFICATION_CHECK" {
  name = "${var.aws_config_name}-config_rule_S3_CLOUDFORMATION_CHECK"

  source {
    owner             = "AWS"
    source_identifier = "CLOUDFORMATION_STACK_NOTIFICATION_CHECK"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_iam_role" "config" {
  name               = "${var.aws_config_name}-config_iam_role"
  assume_role_policy = "${data.template_file.aws_iam_config_assume_role_policy.rendered}"
}

resource "aws_iam_policy" "config" {
  name   = "${var.aws_config_name}-config_iam_policy"
  policy = "${data.template_file.aws_iam_config_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = "${aws_iam_role.config.name}"
  policy_arn = "${aws_iam_policy.config.arn}"
}

resource "aws_s3_bucket" "config" {
  bucket        = "${var.aws_bucket_prefix}-config${length(var.aws_suffix) > 0 ? "-${var.aws_suffix}" : ""}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "config" {
  bucket = "${aws_s3_bucket.config.id}"
  policy = "${data.template_file.aws_s3_config_bucket_policy.rendered}"
}
