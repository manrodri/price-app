variable "project_name" {
  type = string
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