# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "../lambda/employees.js"
  output_path = "../lambda/employees.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com", "apigateway.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "create_policy" {
  statement {
    effect   = "Allow"
    resources = ["*"]
    actions = [
      "dynamodb:ListTables",
    ]
  }

  statement {
    effect   = "Allow"
    resources = ["arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.this.name}"]
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]
  }
}

resource "aws_iam_policy" "create_policy" {
  name = "lambda-policy"
  policy = data.aws_iam_policy_document.create_policy.json
}

resource "aws_iam_role_policy_attachment" "cat_policy" {
  policy_arn = aws_iam_policy.create_policy.arn
  role = aws_iam_role.iam_for_lambda.name
}


resource "aws_lambda_function" "lambda" {
  function_name = "employees"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role    = aws_iam_role.iam_for_lambda.arn
  handler = "employees.handler"
  runtime = "nodejs12.x"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

resource "aws_lambda_permission" "api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}
