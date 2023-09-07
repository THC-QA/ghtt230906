resource "aws_iam_group" "testers" {
  name = "testers"
  path = "/users/"
}

resource "aws_iam_group_membership" "testing_team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name,
  ]

  group = aws_iam_group.testers.name
}

resource "aws_iam_group_policy" "testing_group_policy" {
  name   = "ec2-and-cloudwatch"
  group  = aws_iam_group.testers.name
  policy = data.aws_iam_policy_document.testing_group_policy_document.json
}

data "aws_iam_policy_document" "testing_group_policy_document" {
    statement {
        effect = "Allow"
        actions = [
            "iam:GetAccountPasswordPolicy",
        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        actions = [
            "iam:ChangePassword",
        ]
        resources = [
            "arn:aws:iam::*:user/${aws:username}"
        ]
    }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
    resources = [module.s3_bucket.bucket_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user" "user_one" {
  name = var.name_one
  path = "/users/"

  tags = {
    organisation = "generated-health"
  }
}

resource "aws_iam_access_key" "user_one_key" {
  user = aws_iam_user.user_one.name
}

resource "aws_iam_user" "user_two" {
  name = var.name_two
  path = "/users/"

  tags = {
    organisation = "generated-health"
  }
}

resource "aws_iam_access_key" "user_two_key" {
  user = aws_iam_user.user_two.name
}