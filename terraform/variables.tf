variable "region" {
  description = "The AWS region that we are working in."
  type = string
}

variable "github_org" {
  description = "The name of our org on GitHub"
  type = string
}

variable "oidc_audience" {
  description = "Audience supplied to configure-aws-credentials."
  default     = "sts.amazonaws.com"
}

variable "state_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
}

variable "aws_role_github_actions" {
  description = "The name of the AWS role for GitHub Actions"
  type = string
}

