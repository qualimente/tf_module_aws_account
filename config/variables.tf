//Setup default config variables
variable "aws_config_name" {
  description = "Name for AWS config resources"
  type        = "string"
}

variable "aws_bucket_prefix" {
  description = "Prefix for AWS config bucket"
  type        = "string"
}

variable "aws_suffix" {
  description = "Suffix for AWS resources"
  default     = ""
}
