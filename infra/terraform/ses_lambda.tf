resource "random_pet" "lambda_bucket_name" {
  prefix = "price-app-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id


}

data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/templates/lambda"
  output_path = "${path.module}/ses_deployment.zip"
}

resource "aws_s3_object" "ses_backend" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "ses_deployment.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}


resource "aws_lambda_function" "ses_backend" {
  function_name = "ses_backend-${terraform.workspace}"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.ses_backend.key

  runtime = "python3.7"
  handler = "ses.lambda_handler"
  timeout = 30

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      region = var.region,
      SENDER = var.sender,
      RECIPIENT = var.recipient,
      SUBJECT = var.subject
      smtp_username = var.smtp_username
      smtp_password = var.smtp_password
    }
  }


}

resource "aws_cloudwatch_log_group" "ses_backend" {
  name = "/aws/lambda/${aws_lambda_function.ses_backend.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda_ses"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "ses_policy" {
  name = "${terraform.workspace}-lambda-price-ses"
  role = aws_iam_role.lambda_exec.name

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [

      {
        "Action": [
          "ses:*"
        ],
        "Effect": "Allow",
        "Resource": [
               "*"
            ]
      }
    ]
  }
  EOF
}