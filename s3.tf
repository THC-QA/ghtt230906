module "s3_bucket" {
  depends_on = [
    aws_sns_topic.bucket_alert,
    aws_s3_bucket.log_bucket
  ]
  source                 = "cloudposse/s3-bucket/aws"
  version                = "4.0.0"
  s3_object_ownership    = "BucketOwnerEnforced"
  enabled                = true
  user_enabled           = true
  versioning_enabled     = false
  allowed_bucket_actions = ["s3:GetObject", "s3:ListBucket", "s3:GetBucketLocation"]
  name                   = "ghtt-storage"
  stage                  = var.stage
  namespace              = var.namespace
  logging = [{
    bucket_name = "ghtt-s3-logs"
    prefix      = "log/"
  }]

  #   privileged_principal_arns = [
  #   {
  #     "arn:aws:iam::123456789012:role/principal1" = ["prefix1/", "prefix2/"]
  #   }, {
  #     "arn:aws:iam::123456789012:role/principal2" = [""]
  #   }]
  #   privileged_principal_actions = [
  #     "s3:PutObject", 
  #     "s3:PutObjectAcl", 
  #     "s3:GetObject", 
  #     "s3:DeleteObject", 
  #     "s3:ListBucket", 
  #     "s3:ListBucketMultipartUploads", 
  #     "s3:GetBucketLocation", 
  #     "s3:AbortMultipartUpload"
  #   ]
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "ghtt-s3-logs"
}

# resource "aws_s3_bucket_acl" "log_bucket_acl" {
#   bucket = aws_s3_bucket.log_bucket.id
#   acl    = "log-delivery-write"
# }

# resource "aws_s3_bucket_logging" "ghtt-storage-logging" {
#   bucket = module.s3_bucket.bucket_id

#   target_bucket = aws_s3_bucket.log_bucket.id
#   target_prefix = "log/"
# }