resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3_bucket.bucket_id

  topic {
    id = "NotifyCreated"
    topic_arn     = aws_sns_topic.bucket_alert.arn
    events        = ["s3:ObjectCreated:*"]
  }
}

data "aws_iam_policy_document" "bucket_alert_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.bucket_alert.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [module.s3_bucket.bucket_arn] # causing logic recursion issue with topic and eventsource
    }
  }
}

resource "aws_sns_topic" "bucket_alert" {
  name   = "ghtt-storage-alert-topic"
}

resource "aws_sns_topic_policy" "bucket_alert_policy" {
  arn = aws_sns_topic.bucket_alert.arn
  policy = data.aws_iam_policy_document.bucket_alert_policy_document.json
}

resource "aws_sns_topic_subscription" "bucket_alert_primary_email_target" {
  topic_arn = aws_sns_topic.bucket_alert.arn
  protocol  = "email-json"
  endpoint  = var.primary_email_target
}

resource "aws_sns_topic_subscription" "bucket_alert_secondary_email_target" {
  topic_arn = aws_sns_topic.bucket_alert.arn
  protocol  = "email-json"
  endpoint  = var.secondary_email_target
}