

resource "aws_dynamodb_table" "this" {
  name = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "feedback_id"

  attribute {
    name = "feedback_id"
    type = "S"
  }
}