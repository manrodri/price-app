
variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "profile" {
  type = string
  default = "jenkins"
}

variable "env" {
  description = "Depolyment environment"
  default     = "dev"
}

variable "repository_branch" {
  description = "Repository branch to connect to"
  default     = "develop"
}

variable "repository_owner" {
  description = "GitHub repository owner"
}

variable "repository_name" {
  description = "GitHub repository name"
}

variable "static_web_bucket_name" {
  description = "S3 Bucket to deploy to"
  default     = "static-web-example-bucket-price-app"
}

variable "artifacts_bucket_name" {
  description = "S3 Bucket for storing artifacts"
  default     = "artifacts-bucket"
}

variable "secret_name" {
  type = string
}

variable "repository_url" {
  type = string
}