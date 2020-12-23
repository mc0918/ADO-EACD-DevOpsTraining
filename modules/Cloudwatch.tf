resource "aws_cloudwatch_log_group" "mrc053_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}