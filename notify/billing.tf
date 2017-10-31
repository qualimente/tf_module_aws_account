resource "aws_sns_topic" "billing_notifications" {
  name = "billing-notifications"
}

resource "aws_sns_topic_subscription" "https_sns_subscription_endpoint" {
  count                  = "${length(var.https_sns_subscription_endpoint) > 0 ? 1 : 0}"
  endpoint               = "${var.https_sns_subscription_endpoint}"
  endpoint_auto_confirms = true
  protocol               = "https"
  topic_arn              = "${aws_sns_topic.billing_notifications.arn}"
}

resource "aws_cloudwatch_metric_alarm" "max_estimated_charges_daily_alarm" {
  alarm_name          = "max_estimated_monthly_charges"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "${24 * 60 * 60}"
  statistic           = "Maximum"
  threshold           = "${var.max_estimated_daily_charges_threshold}"

  dimensions {
    Currency = "USD"
  }

  alarm_description = "Daily check of estimated monthly charges exceeded"
  alarm_actions     = ["${aws_sns_topic.billing_notifications.arn}"]
}
