// instantiate the cloudtrail module only supplying required parameters with the intent of really exercising the defaults

module "it_minimal" {
  source = "../../../" //minimal integration test

  aws_account_id      = "621293099824"
  aws_region          = "us-west-2"
  aws_cloudtrail_name = "minimal_name"
  aws_bucket_prefix   = "minimal"
  s3_bucket_name      = "qm-infra-module-ct-logs"
}
