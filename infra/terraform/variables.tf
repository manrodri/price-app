variable "project_name" {
  type    = string
  default = "price-app"
}

variable "accountId" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnet_count" {
  type = map(number)
}


variable "private_subnets" {
  type = map(list(string))
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type    = string
  default = "test-key"
}


variable "private_key_path" {
  type    = string
  default = "/Users/manuelrodriguez/Desktop/aws-keys/test-key.pem"
}
variable "domain_name" {
  default = "manuelrodriguez.cloud"
}

variable "public_subnets" {
  type = map(list(string))
}

######
# dns
######
variable "demo_dns_zone" {
  type    = string
  default = "soydecai.xyz"

}

variable "demo_dns_name" {
  type    = string
  default = "myapp"
}



####
# compute
####

variable "ip_range" {
  default = "0.0.0.0/0"
}

variable "asg_instance_size" {
  type = map(string)
}

variable "asg_max_size" {
  type = map(number)
}
variable "asg_min_size" {
  type = map(number)
}

variable "key" {
  type = string
}


locals {
  common_tags = {
    environment  = terraform.workspace
    team         = "Cloud and Hosting"
    project_name = "demo-project"
  }
}
