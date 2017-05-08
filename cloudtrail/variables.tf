// Setup a default CloudTrail trail.

//Variables
variable "aws_account_id" {
  type        = "string"
  description = "AWS account ID"
}

variable "aws_region" {
  type        = "string"
  description = "Region to run in - cloudtrail logstream"
}

variable "aws_cloudtrail_name" {
  type        = "string"
  description = "Name of CloudTrail trail."
}

variable "s3_bucket_name" {
  type        = "string"
  description = "S3 Bucket for logs"
}

variable "s3_bucket_suffix" {
  type        = "string"
  description = "S3 prefix path for logs"
  default     = ""
}

variable "s3_force_destroy" {
  type        = "string"
  description = "Destroy S3 bucket even if not empty."
  default     = "false"
}

variable "enable_logging" {
  description = "Enable logging, set to 'false' to pause logging."
  default     = true
}

variable "enable_log_file_validation" {
  description = "Create signed digest file to validated contents of logs."
  default     = true
}

variable "include_global_service_events" {
  description = "include evnets from global services such as IAM."
  default     = true
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in all regions or just the current region."
  default     = true
}
