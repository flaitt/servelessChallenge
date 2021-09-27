# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

provider "archive" {}

data "archive_file" "post_zip" {
  type        = "zip"
  source_file = "../lambda/nodejs/employees/postEmployee.js"
  output_path = "../lambda/nodejs/employees/zip/postEmployee.zip"
}

data "archive_file" "get_zip" {
  type        = "zip"
  source_file = "../lambda/nodejs/employees/getEmployee.js"
  output_path = "../lambda/nodejs/employees/zip/getEmployee.zip"
}

data "archive_file" "put_zip" {
  type        = "zip"
  source_file = "../lambda/nodejs/employees/putEmployee.js"
  output_path = "../lambda/nodejs/employees/zip/putEmployee.zip"
}

data "archive_file" "delete_zip" {
  type        = "zip"
  source_file = "../lambda/nodejs/employees/deleteEmployee.js"
  output_path = "../lambda/nodejs/employees/zip/deleteEmployee.zip"
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


resource "aws_lambda_function" "post_employee" {
  function_name = "postEmployee"

  filename         = data.archive_file.post_zip.output_path
  source_code_hash = data.archive_file.post_zip.output_base64sha256

  role    = aws_iam_role.iam_for_lambda.arn
  handler = "postEmployee.handler"
  runtime = "nodejs12.x"

}

resource "aws_lambda_function" "get_employee" {
  function_name = "getEmployee"

  filename         = data.archive_file.get_zip.output_path
  source_code_hash = data.archive_file.get_zip.output_base64sha256

  role    = aws_iam_role.iam_for_lambda.arn
  handler = "getEmployee.handler"
  runtime = "nodejs12.x"

}

resource "aws_lambda_function" "put_employee" {
  function_name = "putEmployee"

  filename         = data.archive_file.put_zip.output_path
  source_code_hash = data.archive_file.put_zip.output_base64sha256

  role    = aws_iam_role.iam_for_lambda.arn
  handler = "putEmployee.handler"
  runtime = "nodejs12.x"

}

resource "aws_lambda_function" "delete_employee" {
  function_name = "deleteEmployee"

  filename         = data.archive_file.delete_zip.output_path
  source_code_hash = data.archive_file.delete_zip.output_base64sha256

  role    = aws_iam_role.iam_for_lambda.arn
  handler = "deleteEmployee.handler"
  runtime = "nodejs12.x"

}

resource "aws_lambda_permission" "api-post" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_employee.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}

resource "aws_lambda_permission" "api-get" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_employee.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}

resource "aws_lambda_permission" "api-put" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_employee.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}

resource "aws_lambda_permission" "api-delete" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_employee.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}
