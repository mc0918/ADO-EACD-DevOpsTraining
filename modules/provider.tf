provider "aws" {
  # source  = "hashicorp/aws"
  # version = "~> 3.0"
  profile = "default"
  region  = var.region
}

provider "archive" {}
