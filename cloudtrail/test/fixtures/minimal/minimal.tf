// instantiate the cloudtrail module only supplying required parameters with the intent of really exercising the defaults

module "it_minimal" {
  source = "../../../" //minimal integration test

  aws_account_id      = "621293099824" // "139710491120" // "621293099824"
  aws_region          = "us-west-2"
  aws_cloudtrail_name = "minimal"
  s3_bucket_name      = "qm-infra-module-ct-logs"

  // required to have a repeatable test
  s3_force_destroy    = true
}
