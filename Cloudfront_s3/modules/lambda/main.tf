
data "archive_file" "this" {
  type = "zip"
  source_dir = "${path.module}/python/"
  output_path = "${path.module}/python/lambda_function.zip"
}


#create lambda and its role

resource "aws_iam_role" "this" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version= "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#attach policy
resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name = "s3-upload-trigger"

  filename = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  timeout      = 10
  memory_size  = 256

  handler  = "lambda_function.lambda_handler"
  runtime  = "python3.10"
  role     = aws_iam_role.this.arn
}