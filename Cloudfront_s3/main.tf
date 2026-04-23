

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

module "iam_user" {
  source = "./modules/iam"
  bucket_arns = [
  module.dev_bucket.bucket_arn,
  module.stage_bucket.bucket_arn
]
 user_name = "dev-upload-user"
  
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
  bucket = module.dev_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Bucket level permission
      {
        Effect = "Allow"
        Principal = {
          AWS = module.iam_user.user_arn
        }
        Action = "s3:ListBucket"
        Resource = module.dev_bucket.bucket_arn
      },

      # Object level permission
      {
        Effect = "Allow"
        Principal = {
          AWS = module.iam_user.user_arn
        }
        Action = "s3:PutObject"
        Resource = "${module.dev_bucket.bucket_arn}/*"
      },

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

