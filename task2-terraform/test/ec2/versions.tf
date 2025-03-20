 terraform {
  required_version = "= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.32.1"
    }
    google = {
      source  = "hashicorp/google"
      version = "= 4.80.0"
    }
  }
} 


