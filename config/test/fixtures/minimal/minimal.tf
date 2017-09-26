// instantiate the config module only supplying required parameters with the intent of really exercising the defaults

module "it_minimal" {
  source = "../../../" //minimal integration test

  aws_config_name   = "minimal"
  aws_bucket_prefix = "qm-infra-module-ct-logs-2017-09-26"
}
