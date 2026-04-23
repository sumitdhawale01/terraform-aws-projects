
#iam replication role
resource "aws_iam_role" "replication_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


#replication IAM role
resource "aws_iam_role_policy" "replication_policy" {
  role = aws_iam_role.replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

    #bucket level
    {
        Effect = "Allow"
        Action=[
            "s3:ListBucket",
            "s3:GetReplicationConfiguration"
        ]
        Resource = [
            var.source_bucket_arn,
            var.destination_bucket_arn
        ]
    },

      # Read from source
    {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = "${var.source_bucket_arn}/*"
    },

      # Write to destination
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = "${var.destination_bucket_arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = var.source_bucket_id
  role   = aws_iam_role.replication_role.arn

  

  rule {
    id     = "replication-rule"
    status = "Enabled"

    filter {}

    destination {
      bucket        = var.destination_bucket_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}

