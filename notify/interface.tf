variable "max_estimated_daily_charges_threshold" {
  description = "Maximum Allowed Estimated Charges"
}

variable "https_sns_subscription_endpoint" {
  default     = ""
  description = "The https endpoint where SNS notifications will be enqueued, e.g. for PagerDuty: https://events.pagerduty.com/integration/YOUR_INTEGRATION/enqueue"
}

output "notify.billing_notification_https_subscription_arn" {
  value = "${aws_sns_topic_subscription.https_sns_subscription_endpoint.arn}"
}
