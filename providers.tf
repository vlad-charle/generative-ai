terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "vsani-tf-state-03082023"
    key            = "terraform.state"
    dynamodb_table = "tf-state-lock"
    profile        = "generative-ai"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  # providers version lock is depracted and will be removed
  region  = var.region
  profile = var.profile
}

# Random Provider
provider "random" {}
