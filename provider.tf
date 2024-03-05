terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}
terraform {
  backend "s3" {
    bucket         = "terraform-myremotestate"
    key            = "timing"
    region         = "ap-south-1"
    dynamodb_table = "timing-lock"
  }
}

