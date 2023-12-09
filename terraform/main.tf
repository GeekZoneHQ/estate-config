terraform {
  backend "s3" {
    # configuration to be provided by CI as -backend-config
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }


  }
}

provider "aws" {
  region = var.region
}
