resource "aws_s3_bucket_metric" "bucket_metrics" {
  bucket = module.s3_bucket.bucket_id
  name   = "GHTTEntireBucket"
}

# Various logs and metrics currently available through Cloudwatch, provision custom dashboard?