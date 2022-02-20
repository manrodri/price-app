resource "aws_dynamodb_table" "users-table" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "email"

  attribute {
    name = "email"
    type = "S"
  }



  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-users-table"})
}

resource "aws_dynamodb_table" "stores-table" {
  name           = "Stores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "url_prefix"
  range_key = "name"

  attribute {
    name = "url_prefix"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  global_secondary_index {
    name               = "name-index"
    hash_key           = "name"
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "ALL"
  }




  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-stores-table"})
}


resource "aws_dynamodb_table" "items-table" {
  name           = "Items"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "_id"
  range_key = "price"

  attribute {
    name = "_id"
    type = "S"
  }

  attribute {
    name = "price"
    type = "S"
  }



  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-items-table"})
}


resource "aws_dynamodb_table" "alerts-table" {
  name           = "Alerts"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "user_email"
  range_key = "_id"

  attribute {
    name = "user_email"
    type = "S"
  }

  attribute {
    name = "_id"
    type = "S"
  }




  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-alerts-table"})
}




