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

# criando integração para lambda post
resource "aws_apigatewayv2_integration" "employees_post" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.post_employee.invoke_arn
}

# criando as rotas para lambda post
resource "aws_apigatewayv2_route" "employees_post" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /v1/employees"
  target    = "integrations/${aws_apigatewayv2_integration.employees_post.id}"
}

# criando integração para lambda get
resource "aws_apigatewayv2_integration" "employees_get" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.get_employee.invoke_arn
}

# criando as rotas para lambda get
resource "aws_apigatewayv2_route" "employees_get" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /v1/employees"
  target    = "integrations/${aws_apigatewayv2_integration.employees_get.id}"
}

# criando integração para lambda put
resource "aws_apigatewayv2_integration" "employees_put" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.put_employee.invoke_arn
}

# criando as rotas para lambda put
resource "aws_apigatewayv2_route" "employees_put" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "PUT /v1/employees"
  target    = "integrations/${aws_apigatewayv2_integration.employees_put.id}"
}

# criando integração para lambda delete
resource "aws_apigatewayv2_integration" "employees_delete" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.delete_employee.invoke_arn
}

# criando as rotas para lambda delete
resource "aws_apigatewayv2_route" "employees_delete" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "DELETE /v1/employees"
  target    = "integrations/${aws_apigatewayv2_integration.employees_delete.id}"
}