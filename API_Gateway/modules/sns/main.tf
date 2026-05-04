resource "aws_sns_topic" "this" {
  name = "feedback-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = "pappubhai0907@gmail.com"  
}

