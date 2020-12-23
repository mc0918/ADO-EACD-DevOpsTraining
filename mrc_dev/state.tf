terraform {
  backend "s3" {
    bucket = "as-ado-sbx-tfstate"
    key    = "wildRydes/dev/terraform.tfstate"
    region = "us-east-2"
  }
}

