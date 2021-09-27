output "lambda" {
  value = aws_lambda_function.lambda.qualified_arn
}

output "api_url" {
  value = aws_apigatewayv2_stage.this.invoke_url
}