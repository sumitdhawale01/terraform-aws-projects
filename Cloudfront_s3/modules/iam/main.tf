
resource "aws_iam_user" "this" {
  name = var.user_name
}


resource "aws_iam_policy" "upload_policy" {
  name = "${var.user_name}-upload-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Object level (upload)
      {
        Effect = "Allow"
        Action = ["s3:PutObject"]
        Resource = [
          for arn in var.bucket_arns : "${arn}/*"
        ]
      },

      # Bucket level (list specific buckets)
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = var.bucket_arns
      },

      # Optional (list all buckets in console)
      {
        Effect = "Allow"
        Action = ["s3:ListAllMyBuckets"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.upload_policy.arn
}