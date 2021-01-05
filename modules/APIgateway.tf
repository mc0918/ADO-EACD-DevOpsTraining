# API Gateway for WildRydes
resource "aws_api_gateway_rest_api" "mrc053_api" {
    name = "mrc053_api"
    description = "terraform tutorial api gateway"
    tags = {
        "app_name" = var.app_name
        "env"      = var.env
      }
}

# Cognito User Pool with WildRydes users
data "aws_cognito_user_pools" "mrc053_users" {
    depends_on = [aws_cognito_user_pool.mrc053_WildRydes_pool]
    name = aws_cognito_user_pool.mrc053_WildRydes_pool.name

}

# Authroizer for API Gateway, allows users access via Cognito
resource "aws_api_gateway_authorizer" "mrc053_auth" {
    name = "mrc053_api"
    rest_api_id = aws_api_gateway_rest_api.mrc053_api.id
    authorizer_uri = aws_lambda_function.mrc053_WildRydes_lambdafunc.invoke_arn
    authorizer_credentials = aws_iam_role.mrc053_wildrydeslambda_role.arn
    type = "COGNITO_USER_POOLS"
    provider_arns = data.aws_cognito_user_pools.mrc053_users.arns
}

# Creates ride resource (aka '/ride') in API Gateway
resource "aws_api_gateway_resource" "ride" {
    rest_api_id = aws_api_gateway_rest_api.mrc053_api.id
    parent_id = aws_api_gateway_rest_api.mrc053_api.root_resource_id
    path_part = "ride"

}

# POST method for /ride
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.mrc053_api.id
  resource_id   = aws_api_gateway_resource.ride.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.mrc053_auth.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Integration that allows lambda to be invoked via POST to /ride
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.mrc053_api.id
  resource_id             = aws_api_gateway_resource.ride.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mrc053_WildRydes_lambdafunc.invoke_arn
}

# Deploys API to dev stage
resource "aws_api_gateway_deployment" "deployment" {
    depends_on = [aws_api_gateway_integration.integration]
    rest_api_id = aws_api_gateway_rest_api.mrc053_api.id
    stage_name = "dev"
}
