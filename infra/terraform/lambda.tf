resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${terraform.workspace}-lambda-price-dynamo"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:*"
        ],
        "Effect": "Allow",
        "Resource": [
               "arn:aws:dynamodb:${var.region}:${var.accountId}:table/${aws_dynamodb_table.alerts-table.name}",
               "arn:aws:dynamodb:${var.region}:${var.accountId}:table/${aws_dynamodb_table.items-table.name}"

            ]
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "templates/lambda/deployment_package.zip"
  function_name = "alert_updater"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "alert_updater.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("templates/lambda/deployment_package.zip")

  runtime = "python3.7"

  environment {
    variables = {
      foo = "bar"
    }
  }
}