terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = "ap-south-1"
}

module "dynamodb" {
  source = "./modules/DynamoDB"
  table_name = "feedback-table"
   
}

module "iam" {
  source = "./modules/iam"
}

module "sqs" {
  source = "./modules/sqs"
  queue_name = "feedback-queue-v2"

}

module "sns" {
  source = "./modules/sns"
}

module "lambda_validator" {
  source = "./modules/lambda_validator"
  function_name = "submit-feedback"
  role_arn = module.iam.lambda_role_arn
  table_name = module.dynamodb.table_name
  queue_url = module.sqs.queue_url

}
module "lambda_processor" {
  source = "./modules/lambda_processor"
  function_name = "process-feedback-v2"
  role_arn   = module.iam.lambda_role_arn
  table_name = module.dynamodb.table_name
  topic_arn  = module.sns.topic_arn
  
}

module "apigateway" {
  source = "./modules/ApiGateway"
  lambda_name = module.lambda_validator.function_name

  lambda_invoke_arn = module.lambda_validator.invoke_arn

}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = module.sqs.queue_arn
  function_name    = module.lambda_processor.function_name
  batch_size       = 1
}