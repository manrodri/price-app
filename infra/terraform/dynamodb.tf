resource "aws_dynamodb_table" "users-table" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "email"

  attribute {
    name = "email"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-users-table"})
}