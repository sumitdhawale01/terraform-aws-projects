output "user_name" {
  value = aws_iam_user.this.name
}

output "user_arn" {
  value = aws_iam_user.this.arn
}

output "policy_arn" {
  value = aws_iam_policy.upload_policy.arn
}