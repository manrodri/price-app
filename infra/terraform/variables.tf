variable "project_name" {
  type    = string
  default = "price-app"
}

variable "subnet_count" {
  type = number
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type = string
  default = "test-key"
}


variable "private_key_path" {
  type = string
  default = "/Users/manuelrodriguez/Desktop/aws-keys/test-key.pem"
}
variable "domain_name" {
  default = "manuelrodriguez.cloud"
}


locals {
  s3_bucket_name = "${var.project_name}-${random_integer.rand.result}"
  common_tags = {
    Environment = terraform.workspace

  }
}