terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
