##################################################################################
# RESOURCES
##################################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = "${local.common_tags["project_name"]}-${terraform.workspace}}"

  cidr            =  "10.0.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, var.subnet_count[terraform.workspace]) // slice extracts some consecutive elements from within a list. slice(list, startindex, endindex)
  private_subnets = var.private_subnets[terraform.workspace]
  public_subnets  = var.public_subnets[terraform.workspace]

  enable_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = false


  tags = local.common_tags
}