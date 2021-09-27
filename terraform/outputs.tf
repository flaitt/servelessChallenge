output "lambda" {
  value = aws_lambda_function.post_employee.qualified_arn
}

output "api_url" {
  value = aws_apigatewayv2_stage.this.invoke_url
}