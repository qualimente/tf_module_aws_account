// Setup a default password_policy variables

//Variables
variable "aws_password_minimum_length" {
  description = "The mimimum length of password to apply."
  default     = "10"
}

variable "aws_password_require_lowercase" {
  description = "Require lowercase in password, default set to true"
  default     = true
}

variable "aws_password_require_numbers" {
  description = "Require numbers in password, default set to true"
  default     = true
}

variable "aws_password_require_uppercase" {
  description = "Require uppercase in password, default set to true"
  default     = true
}

variable "aws_password_require_symbols" {
  description = "Require symbols in password, default set to false"
  default     = true
}

variable "aws_password_max_age" {
  description = "Defines max age of password before expiring, default set to 90"
  default     = "90"
}

variable "aws_password_reuse" {
  description = "Defines number of previous passwords to check against for reuse, default 16"
  default     = "8"
}

variable "aws_password_allow_change_by_user" {
  description = "allow user to change password, default set to true"
  default     = true
}

variable "aws_password_expiration_lock" {
  description = "at login check for expiring password and lock if expired, default set to true"
  default     = true
}
