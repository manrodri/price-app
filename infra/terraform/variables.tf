variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
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

variable "common_tags" {
  type = map(string)
}