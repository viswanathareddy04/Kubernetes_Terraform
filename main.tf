terraform {
  required_providers {
    aws = ">= 2.7.0"
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}