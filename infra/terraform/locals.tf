##################################################################################
# LOCALS
##################################################################################

locals {
  asg_instance_size = "t2.small"
  asg_max_size      = 2
  asg_min_size      = 1
  common_tags = merge(var.common_tags,
    {
      Environment = terraform.workspace
    }
  )

}