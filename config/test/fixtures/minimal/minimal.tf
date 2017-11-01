// instantiate the config module only supplying required parameters with the intent of really exercising the defaults

resource "random_id" "testing_suffix" {
  byte_length = 4
}

module "it_minimal" {
  source = "../../../" //minimal integration test

  aws_config_name = "test-${random_id.testing_suffix.hex}"
  s3_bucket_name  = "qm-infra-module-config-test-${random_id.testing_suffix.hex}"
}
