variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "ip_address" {
  description = "My IP address in CIDR notation to allow SSH access"
  type        = string
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"  
}
