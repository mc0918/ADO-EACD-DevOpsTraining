resource "aws_cognito_user_pool" "mrc053_WildRydes_pool" {
  name = "mrc053-WildRydes"
  tags = {
    "app_name" = var.app_name
    "env"      = var.env
  }
}

resource "aws_cognito_user_pool_client" "mrc053_WildRydes_client" {
  name = "mrc053-WildRydes-Client"
  user_pool_id = aws_cognito_user_pool.mrc053_WildRydes_pool.id
}