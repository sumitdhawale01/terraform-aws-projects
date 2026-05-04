resource "aws_sqs_queue" "main" {
  name = var.queue_name

  # Keep this reasonable for Lambda processing
  visibility_timeout_seconds = 60

  # Long polling (better efficiency)
  receive_wait_time_seconds = 10
}