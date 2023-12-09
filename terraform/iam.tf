resource "aws_iam_role" "role" {
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