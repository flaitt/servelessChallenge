# Criando recurso api
resource "aws_apigatewayv2_api" "this" {
  name          = "employees-api"
  protocol_type = "HTTP"
}

# Criando recurso stage
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "employees-stage"
  auto_deploy = true
}

# criando integração
resource "aws_apigatewayv2_integration" "employees" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.lambda.invoke_arn
}

# criando as rotas
resource "aws_apigatewayv2_route" "employees" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /v1/employees"
  target    = "integrations/${aws_apigatewayv2_integration.employees.id}"
}