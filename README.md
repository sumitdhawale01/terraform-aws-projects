# terraform-aws-projects- Secure S3 Data Lifecycle & Event-Driven Automation System

1- Create 2 S3 bucket named as Dev and Stage.
2- Follow security best practice while creating S3 bucket.
3- Create an IAM policy with upload access only.
4- Create an IAM user and attach policy to it. Login with user and check user should be able to upload the document nothing else.
5- Update the Bucket policy that only above user should be able to access the bucket.
6- Enable logging of S3 buckets
7- Create life cycle rule in S3 bucket
After 30 days → Move to Standard-IA
After 60 days → Move to Glacier
After 90 days → Delete
8- Enable versioning on bucket. Upload some files and then delete them and try to restore them from archive.
9- If you upload a file in Dev Bucket it should be automatically copied in Stage Bucket and vice versa.
10- Try to host static website using S3 bucket without making the bucket public.
11- Try to trigger lambda function if some file is uploaded on the S3 bucket.
12- Upload some Image in private S3 bucket and try to call it publically using presigned URL.
