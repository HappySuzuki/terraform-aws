terraform {
  backend "s3" {
    bucket         = "beanstalk-app-demo-tf-state"
    key            = "apps/beanstalk/staging/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  environment_name = "staging"
}

module "beanstalk_app" {
  source = "../module"

  app_name         = "beanstalk-app-${local.environment_name}"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  env_vars         = var.env_vars
}

# resource "aws_s3_bucket" "terraform_state" {
#   bucket        = "beanstalk-app-demo-tf-state"
#   force_destroy = true
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name           = "terraform-state-locking"
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 2
#   write_capacity = 2
#   hash_key       = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
