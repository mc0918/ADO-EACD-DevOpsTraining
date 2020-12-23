resource "aws_dynamodb_table" "mrc-Rides2" {
    name = "mrc-Rides2"
    hash_key       = "RideId"
    billing_mode   = "PAY_PER_REQUEST"

    attribute {
      name = "RideId"
      type = "S"
    }

    tags = {
    "app_name" = var.app_name
    "env"      = var.env
  }
}