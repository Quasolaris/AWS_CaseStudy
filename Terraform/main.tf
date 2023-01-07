# Credentials for Terrafom and AWS-CLI
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  token = "${var.aws_session_token}"
  region = "${var.region}"
}


#========[ S3 BUCKET ]==============
resource "aws_s3_bucket" "webpage_bucket_casestudy_fhnw" {
  bucket = "${var.s3Bucket}"
  acl = "${var.acl_value}"

  tags = {
    "use": "static webpage",
    "loadbalanced": "yes"
  }
}

resource "aws_s3_bucket_cors_configuration" "webpage_config" {
  bucket = "${var.s3Bucket}"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_object" "file_upload_index" {
  bucket      =  "${var.s3Bucket}"
  key         =  "index.html"
  acl         = "public-read"
  source      =  "${path.module}/webpage/index.html"
  content_type = "text/html"

  depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}


resource "aws_s3_object" "file_upload_error" {
  bucket      =  "${var.s3Bucket}"
  key         =  "error.html"
  acl         = "public-read"
  source      =  "${path.module}/webpage/error.html"
  content_type = "text/html"

  depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}



resource "aws_s3_bucket_website_configuration" "case_study_webpage_fhnw" {
  bucket =  "${var.s3Bucket}"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [
    aws_s3_object.file_upload_index,
    aws_s3_object.file_upload_error
  ]
}

resource "aws_s3_bucket_policy" "prod_website" {
  bucket =  "${var.s3Bucket}"
  policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
          {
              "Sid": "PublicReadGetObject",
              "Effect": "Allow",
              "Principal": "*",
              "Action": [
                 "s3:GetObject"
              ],
              "Resource": [
                 "arn:aws:s3:::${var.s3Bucket}/*"
              ]
              },
              {
              "Effect": "Allow",
              "Principal": {
                "AWS": "arn:aws:iam::127311923021:root"
              },
              "Action": "s3:PutObject",
              "Resource": "arn:aws:s3:::${var.s3Bucket}/AWSLogs/${var.account_id}/*"
            }
          ]
    }
    POLICY
  depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}

resource "aws_s3_access_point" "s3_accesspoint_fhnw_pcls" {
  bucket = "${var.s3Bucket}"
  name   = "lambdavaluespage"

  depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}
#========[ S3 BUCKET ]==============


#========[ Certificates ]==============
#==========================================================
# following is the needed cert creation for HTTPS

resource "tls_private_key" "fhnw_private_casestudy" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

# The error for a missing value can be ignored (new Terraform rule, field is READONLY)
resource "tls_self_signed_cert" "cert_fhnw_casestudy" {

  private_key_pem = tls_private_key.fhnw_private_casestudy.private_key_pem

  subject {
    common_name  = "${var.s3Bucket}.s3.amazonaws.com"
    organization = "FHNW PCLS CaseStudy"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  depends_on = [tls_private_key.fhnw_private_casestudy]
}


resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.fhnw_private_casestudy.private_key_pem
  certificate_body = tls_self_signed_cert.cert_fhnw_casestudy.cert_pem

  depends_on = [tls_self_signed_cert.cert_fhnw_casestudy]
}

resource "aws_iam_server_certificate" "fhnw_cert" {
  name             = "fhnw_cert"
  private_key      = tls_private_key.fhnw_private_casestudy.private_key_pem
  certificate_body = tls_self_signed_cert.cert_fhnw_casestudy.cert_pem

  depends_on = [tls_self_signed_cert.cert_fhnw_casestudy]

}

# ==============================================================
#========[ Certificates ]==============


#========[ LoadBalancer ]==============
resource "aws_elb" "loadbalancer_casestudy_fhnw" {
  name               = "${var.laodbalancer}"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]


  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # comment in for HTTPS

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::${var.account_id}:server-certificate/fhnw_cert" #change to your AWS id
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }


  access_logs {
    bucket = "${var.s3Bucket}"
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "loadbalancer-http-8080"
  }

  depends_on = [
    aws_s3_bucket_policy.prod_website,
    # comment the fhnw_cert if already run once
    aws_iam_server_certificate.fhnw_cert
  ]
}
#========[ LoadBalancer ]==============

#========[ Lambda ]==============
# deploy lambda function
resource "aws_lambda_function" "lambda_aws_cli" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name             = "${var.lambdaname}"
  role                      = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler          = "func.handler"
  runtime          = "python3.8"


  depends_on = [
    aws_cloudwatch_log_group.aws_cli_log_group
  ]

  tags = var.tags
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir = "../Lambda/"
  output_path = "../Lambda/packedlambda.zip"
}

resource "aws_lambda_function_url" "casestudy_lambda_url" {
  function_name      = aws_lambda_function.lambda_aws_cli.function_name
  authorization_type = "NONE"
  depends_on = [aws_lambda_function.lambda_aws_cli]

  cors {
    allow_credentials = true
    allow_origins     = ["http://${var.s3Bucket}.s3-website-us-east-1.amazonaws.com"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date", "Access-Control-Allow-Origin", "Access-Control-Allow-Headers"]
    max_age           = 86400
  }
}
#========[ Lambda ]==============



#========[ API-GateWay ]==============
resource "aws_api_gateway_rest_api" "lambda_casestudy_api_gateway" {
  name        = "LambdaAPI"
  description = "API Gateway for Lambda Trigger"
  depends_on = [aws_lambda_function_url.casestudy_lambda_url
  ]
}


resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_aws_cli.function_name}"
  principal     = "apigateway.amazonaws.com"
  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.lambda_casestudy_api_gateway.execution_arn}/*/*"
}



resource "aws_api_gateway_method" "proxy_lambda" {
  rest_api_id   = "${aws_api_gateway_rest_api.lambda_casestudy_api_gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.lambda_casestudy_api_gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"

  depends_on = [
    aws_api_gateway_rest_api.lambda_casestudy_api_gateway
  ]
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_casestudy_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_lambda.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_lambda.http_method}"

  integration_http_method = "POST"
  type                    = "MOCK"
  uri                     = "${aws_lambda_function.lambda_aws_cli.invoke_arn}"

  depends_on = [
    aws_api_gateway_method.proxy_lambda
  ]
}


resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
    aws_lambda_function_url.casestudy_lambda_url,
    aws_api_gateway_method.proxy_lambda,
    aws_api_gateway_integration.lambda
  ]
  stage_name  = "trigger"
  rest_api_id = "${aws_api_gateway_rest_api.lambda_casestudy_api_gateway.id}"
}

#========[ API-GateWay ]==============


#========[ CloudWatch ]==============
resource "aws_cloudwatch_log_group" "aws_cli_log_group" {
  name              = "/aws/lambda/casestudylambda"
  retention_in_days = 14

  tags = var.tags

}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF

}
#========[ CloudWatch ]==============


#========[ CloudFront ]==============
resource "aws_cloudfront_distribution" "webpage_cf_cdn_casestudy_fhnw" {

  origin {
    //domain_name = aws_s3_bucket.webpage_bucket_casestudy_fhnw.website_endpoint
    domain_name = aws_s3_bucket.webpage_bucket_casestudy_fhnw.bucket_domain_name
    origin_id   = "http://${var.s3Bucket}.s3-website-us-east-1.amazonaws.com"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
  }


  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "http://${var.s3Bucket}.s3-website-us-east-1.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA", "CH"]
    }
  }

  tags = var.tags



  viewer_certificate {
    cloudfront_default_certificate = true
  }


  depends_on = [
    aws_s3_bucket_policy.prod_website
  ]
}
#========[ CloudFront ]==============