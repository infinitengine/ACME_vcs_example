terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    stackpath = {
      source = "stackpath/stackpath"
      version = "1.4.0"
  }
 }

  required_version = ">= 0.14.0"
}
