resource "aws_iam_role" "github_actions" {
  name = var.aws_role_github_actions

  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity",
      Effect    = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_oidc.arn
      },
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = var.oidc_audience
        },
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/*"
        }
      }
    }],
    Version = "2012-10-17"
  })
}

moved {
  from = aws_iam_role.role
  to   = aws_iam_role.github_actions
}


resource "aws_iam_policy" "github_actions_s3_policy" {
  name        = "GitHubActionsS3Policy"
  description = "Policy for GitHub Actions role to access Terraform state bucket"

  policy = data.aws_iam_policy_document.github_actions_s3_policy.json
}

data "aws_iam_policy_document" "github_actions_s3_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:ListBucketVersions",
      "s3:GetObjectVersion",
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_policy_attachment" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_s3_policy.arn
}
