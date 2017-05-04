// instantiate the cloudtrail module only supplying required parameters with the intent of really exercising the defaults

module "it_minimal" {  //minimal integration test
  source = "../../../"

  aws_account_id = "a test AWS account id"
  aws_bucket_prefix = "ct_minimal_bucket_prefix"
  aws_region = "us-west-2"
  aws_cloudtrail_name = "minimal_name"
  s3_bucket_name = "qm-infra-module-ct-logs"
}
