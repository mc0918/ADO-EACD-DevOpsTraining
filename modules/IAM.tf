# IAM role with lambda permissions
resource "aws_iam_role" "mrc053_wildrydeslambda_role" {
    description = "terraform training role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "dynamodb.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      },
    {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
  tags = {
    "app_name" = var.app_name
    "env"      = var.env
  }
}

# IAM policy for lambda to write to DyanmoDB
resource "aws_iam_policy" "mrc053_wildrydeslambda_policy" {
  description = "terraform training policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Basic IAM poolicy for lambda to produce logs
resource "aws_iam_role_policy_attachment" "AWS_policy" {
  policy_arn = aws_iam_policy.mrc053_wildrydeslambda_policy.arn
  role       = aws_iam_role.mrc053_wildrydeslambda_role.name
}

# Inline IAM policy allowing lambda to write to DynamoDB... not sure which one works
resource "aws_iam_role_policy" "inline_policy" {
  name = "DynamoDBWriteAccess"
  role = aws_iam_role.mrc053_wildrydeslambda_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "DynamoDB:PutItem"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}