// instantiate the cloudtrail module only supplying required parameters with the intent of really exercising the defaults

provider "aws" {
  region = "us-east-1"
}

module "it_minimal" {
  source = "../../../" //minimal integration test

  max_estimated_daily_charges_threshold = "300"
  https_sns_subscription_endpoint       = "https://events.pagerduty.com/integration/d99ed3be29204c5799361c118deaba86/enqueue"
}
