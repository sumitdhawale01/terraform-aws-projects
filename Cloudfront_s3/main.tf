

provider "aws" {
  region = "ap-south-1"
}

#create dev bucket
module "dev_bucket" {
 depends_on = [module.log_bucket]
  source = "./modules/s3_bucket"
  bucket_name = "sumit-dhawale-sample-dev-bucket-111"
  environment = "dev"
 
  enable_logging  = true
  log_bucket = module.log_bucket.bucket_id

}

#create stage bucket
module "stage_bucket" {
  depends_on = [module.log_bucket]
  source = "./modules/s3_bucket"
  bucket_name = "sumit-dhawale-sample-stage-bucket-222"
  environment = "stage"
  enable_logging = true
  log_bucket = module.log_bucket.bucket_id
}


#create logs bucket
module "log_bucket" {
 
  source = "./modules/s3_bucket"
  bucket_name = "sumit-dhawale-sample-logs-bucket-333"
  environment = "logs"
  enable_logging  = false

}

#iam user module
module "iam_user" {
  source = "./modules/iam"
  bucket_arns = [
  module.dev_bucket.bucket_arn,
  module.stage_bucket.bucket_arn
]
 user_name = "dev-upload-user"
  
}


#cloudfront module
module "cloudfront" {
  source = "./modules/cloudfront"
  bucket_domain_name = module.dev_bucket.bucket_regional_domain_name
}


#lambda module
module "lambda" {
  source = "./modules/lambda"
  filename = "lambda.zip"
}




# dev-stage Replication module
module "replication" {
  source = "./modules/replication"
  role_name = "dev-to-stage-replication-role"
  source_bucket_arn = module.dev_bucket.bucket_arn
  source_bucket_id = module.dev_bucket.bucket_id

  destination_bucket_arn = module.stage_bucket.bucket_arn

}

#stage-dev replication module
module "replication_stage_to_dev" {
  source = "./modules/replication"
  role_name = "stage-to-dev-replication-role"
  source_bucket_arn      = module.stage_bucket.bucket_arn
  source_bucket_id       = module.stage_bucket.bucket_id
  destination_bucket_arn = module.dev_bucket.bucket_arn
}

#############
# dev bucket policy
################

resource "aws_s3_bucket_policy" "dev_bucket_policy" {
  depends_on = [module.cloudfront]

  bucket = module.dev_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # IAM user access
      {
        Effect = "Allow"

        Principal = {
          AWS = module.iam_user.user_arn
        }
        Action   = "s3:ListBucket"
        Resource = module.dev_bucket.bucket_arn
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = module.iam_user.user_arn
        }
        Action   = "s3:PutObject"
        Resource = "${module.dev_bucket.bucket_arn}/*"
      },

      # Replication access
      {
        Effect = "Allow"
        Principal = {
          AWS = module.replication_stage_to_dev.replication_role_arn
        }
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Resource = "${module.dev_bucket.bucket_arn}/*"
      },

      # ✅ CloudFront access (merged here)
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.dev_bucket.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront.distribution_arn
          }
        }
      }

    ]
  })
}

###########
# stage bucket policy
###########

resource "aws_s3_bucket_policy" "stage_bucket_policy" {
  depends_on = [ module.replication ]  

  bucket = module.stage_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # IAM user access
      {
        Effect = "Allow"
        Principal = {
          AWS = module.iam_user.user_arn
        }
        Action = "s3:ListBucket"
        Resource = module.stage_bucket.bucket_arn
      },

      {
        Effect = "Allow"
        Principal = {
          AWS = module.iam_user.user_arn
        }
        Action = "s3:PutObject"
        Resource = "${module.stage_bucket.bucket_arn}/*"
      },

      # REQUIRED for replication
      {
        Effect = "Allow"
        Principal = {
          AWS = module.replication.replication_role_arn
        }
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Resource = "${module.stage_bucket.bucket_arn}/*"
      }
    ]
  })
}

######
# lambda-s3-permissions
######

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_name
  principal     = "s3.amazonaws.com"

  source_arn = module.dev_bucket.bucket_arn
}

# Trigger Lambda on upload
resource "aws_s3_bucket_notification" "this" {
  bucket = module.dev_bucket.bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.this]
}