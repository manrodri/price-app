project_name = "price-app"
domain_name  = "soydecai.xyz"

public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
subnet_count    = 2

common_tags = {
  Team         = "Network"
  Project_name = "price-app"
}