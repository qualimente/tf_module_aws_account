// Provide config resource here
data "template_file" "aws_iam_config_assume_role_policy" {
  template = "${file("${path.module}/aws_iam_config_assume_role_policy.tpl")}"
}

data "template_file" "aws_iam_config_policy" {
  template = "${file("${path.module}/aws_iam_config_policy.tpl")}"
}

resource "aws_config_configuration_recorder" "config" {
  name     = "${var.aws_config_name}-config_recorder"
  role_arn = "${aws_iam_role.config.arn}"
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = "${var.aws_config_name}-config_recorder_status"
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
  bucket = "${var.aws_bucket_prefix}-config${length(var.aws_suffix) > 0 ? "-${var.aws_suffix}" : ""}"
}
