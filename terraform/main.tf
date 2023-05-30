terraform {
  backend "s3" {
    bucket         = "todo-webapp-terraform-state"
    key            = "tf-infra/todo-webapp/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "todo-webapp-state-locking"
    encrypt        = true
    # profile        = "terraform-labs-user"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

