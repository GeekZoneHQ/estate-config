resource "aws_iam_role" "github_actions" {
  name = var.aws_role_github_actions
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    principals {
      type        = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_oidc.arn,
      ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:${var.github_org}/*",
      ]

    }
  }
}



resource "aws_iam_policy" "github_actions_policy" {
  name        = "GitHubActionsPolicy"
  description = "Policy for GitHub Actions role to access Terraform state bucket"

  policy = data.aws_iam_policy_document.github_actions_policy.json
}

data "aws_iam_policy_document" "github_actions_policy" {

  # S3 Actions
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
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetReplicationConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketLogging",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetLifecycleConfiguration",
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*",
    ]
  }

  # IAM Actions
  statement {
    actions = [
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetServiceLastAccessedDetails",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
    ]
    effect = "Allow"
    resources = [
      aws_iam_openid_connect_provider.github_oidc.arn,
      aws_iam_role.github_actions.arn,
    ]
  }

  # STS actions
  statement {
    actions = [
      "sts:GetCallerIdentity",
      "sts:AssumeRole",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  # KMS actions
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:kms:*:${var.aws_account_id}:key/*",
    ]
  }

}

resource "aws_iam_role_policy_attachment" "github_actions_s3_policy_attachment" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
#  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
