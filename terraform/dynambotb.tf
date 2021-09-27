#criando recurso db
resource "aws_dynamodb_table" "this" {
  name         = "Employees"
  hash_key     = "Id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "N"
  }
}