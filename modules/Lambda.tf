data "archive_file" "lambda_zip" {                                                                                                                                                                                   
  type        = "zip"                                                                                                                                                                                                
  source_file  = "../modules/Files_lambda_S3/requestUnicorn.js"                                                                                                                                                                                         
  output_path = "../modules/Files_lambda_S3/lambda_package.zip"                                                                                                                                                                      
} 

resource "aws_lambda_function" "mrc053_WildRydes_lambdafunc" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.lambda_name
  role          = aws_iam_role.mrc053_wildrydeslambda_role.arn
  handler       = "lambda.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  runtime = "nodejs12.x"

  depends_on = [
    aws_iam_role_policy_attachment.AWS_policy,
    aws_cloudwatch_log_group.mrc053_log_group,
  ]

  tags = {
    "app_name" = var.app_name
    "env"      = var.env
  }   
}