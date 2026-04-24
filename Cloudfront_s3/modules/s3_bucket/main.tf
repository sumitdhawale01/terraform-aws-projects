
##########################################################
#create Dev Buckets
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    Name = var.bucket_name
    Environment = var.environment
  }
}

#block public access of dev bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls = true
  block_public_policy = true    
  ignore_public_acls = true
  restrict_public_buckets = true
}

# add encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
    bucket = aws_s3_bucket.this.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }

}


#enable versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

 versioning_configuration {
   status = "Enabled"
 
#  depends_on = [
#     aws_s3_bucket_replication_configuration.replication
#   ]

}
}

#lifecycle rule
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id = "lifecycle-rule"
    status = "Enabled"

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}


#Logging

resource "aws_s3_bucket_logging" "this" {
  count = var.enable_logging ? 1 : 0

  bucket = aws_s3_bucket.this.id
  target_bucket = var.log_bucket
  target_prefix = "${var.bucket_name}/logs/"
}








##########################################################

