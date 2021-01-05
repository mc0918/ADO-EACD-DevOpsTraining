# Provisions s3 bucket to host static WildRydes site
resource "aws_s3_bucket" "mrc053_wildrydes_site" {
    bucket = var.app_name
    acl = "public-read"
    policy = templatefile("../modules/templates/policy_clientbucket.json", {
        app_name = var.app_name
        env = var.env
    })

    website {
        index_document = "index.html"
        error_document = "error.html"
        routing_rules = <<EOF
    [{
      "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
    }]
    EOF
    }
    tags = {
    "app_name" = var.app_name
    "env"      = var.env
  }
}

# DONE IN JENKINS... Uncomment to have a website to test before using Jenkins
# resource "aws_s3_bucket_object" "html_object" {
#   for_each = fileset("../clientSideFiles/", "*.html")
#   bucket = aws_s3_bucket.mrc053_wildrydes_site.id
#   key = each.value
#   source = "../clientSideFiles/${each.value}"
#   etag = filemd5("../clientSideFiles/${each.value}")
#   content_type = "text/html"
# }

# resource "aws_s3_bucket_object" "js_object" {
#   for_each = fileset("../clientSideFiles/", "**/*.js")
#   bucket = aws_s3_bucket.mrc053_wildrydes_site.id
#   key = each.value
#   source = "../clientSideFiles/${each.value}"
#   etag = filemd5("../clientSideFiles/${each.value}")
#   content_type = "application/javascript"
# }

# resource "aws_s3_bucket_object" "css_object" {
#   for_each = fileset("../clientSideFiles/", "**/*.css")
#   bucket = aws_s3_bucket.mrc053_wildrydes_site.id
#   key = each.value
#   source = "../clientSideFiles/${each.value}"
#   etag = filemd5("../clientSideFiles/${each.value}")
#   content_type = "text/css"
# }

# resource "aws_s3_bucket_object" "png_object" {
#   for_each = fileset("../clientSideFiles/", "**/*.png")
#   bucket = aws_s3_bucket.mrc053_wildrydes_site.id
#   key = each.value
#   source = "../clientSideFiles/${each.value}"
#   etag = filemd5("../clientSideFiles/${each.value}")
#   content_type = "image/png"
# }

# resource "aws_s3_bucket_object" "jpg_object" {
#   for_each = fileset("../clientSideFiles/", "**/*.jpg")
#   bucket = aws_s3_bucket.mrc053_wildrydes_site.id
#   key = each.value
#   source = "../clientSideFiles/${each.value}"
#   etag = filemd5("../clientSideFiles/${each.value}")
#   content_type = "image/jpg"
# }

# resource "aws_s3_bucket_object" "gif_object" {
#   for_each = fileset("../clientSideFiles/", "**/*.gif")
#   bucket = aws_s3_bucket.mrc053_wildrydes_site.id
#   key = each.value
#   source = "../clientSideFiles/${each.value}"
#   etag = filemd5("../clientSideFiles/${each.value}")
#   content_type = "image/gif"
# }

# config.js for WildRydes (see AWS tutorial)
resource "aws_s3_bucket_object" "config_object" {
  bucket = aws_s3_bucket.mrc053_wildrydes_site.id
  key    = "js/config.js"
  content = templatefile("../modules/templates/config_for_S3.tpl", {
    userPoolId = aws_cognito_user_pool.mrc053_WildRydes_pool.id
    userPoolClientId = aws_cognito_user_pool_client.mrc053_WildRydes_client.id
    region = var.region
    invokeUrl = aws_api_gateway_deployment.deployment.invoke_url
  })
  content_type = "application/javascript"

  etag = "filemd5(../modules/templates/config_for_S3.tpl)"
}

output url {
  value       = "${aws_s3_bucket.mrc053_wildrydes_site.bucket}.s3-website-${var.region}.amazonaws.com"
  description = "static site url"
}

# Bucket access policy to allow users to access site
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.mrc053_wildrydes_site.id
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = false
  restrict_public_buckets = false
}