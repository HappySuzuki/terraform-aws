terraform {
  backend "s3" {
    bucket         = "web-app-demo-tf-state"
    key            = "apps/web-app/staging/terraform.tfstate"
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

variable "db_pass" {
  description = "password for database"
  type        = string
  sensitive   = true
}

locals {
  environment_name = "staging"
}

module "web_app" {
  source = "../module"

  bucket_prefix    = "web-app-data-${local.environment_name}"
  app_name         = "web-app"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  db_name          = "${local.environment_name}mydb"
  db_user          = "db_user"
  db_pass          = var.db_pass
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "web-app-demo-tf-state"
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-state-locking"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
