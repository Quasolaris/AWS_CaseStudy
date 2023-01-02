provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    token = "${var.aws_session_token}"
    region = "${var.region}"
}

module "s3" {
    source = "../S3"
    bucket_name = "s3-static-webpage-casestudy-fhnw"
}

#module "cdn" {
#    source = "../CDN"
#}

data "template_file" "pom_template" {

  template = file("../Lambda/templates/pom.tpl")
  
  vars = {
    artifact      = "casestudylambda"
    version       = "1.4" # change version number in order to redeploy the function
    description   = "case-study-lambda Lambda Function"
  }
}

resource "local_file" "pom_xml" {
  content         = data.template_file.pom_template.rendered
  filename        = "../Lambda/pom.xml"
}


resource "null_resource" "build" {
  
  provisioner "local-exec" {
      command = "mvn package -f ../Lambda/pom.xml"
  }

  depends_on = [
    local_file.pom_xml
  ]
  
}

locals {

    lambda_payload_filename = "../Lambda/target/casestudylambda-1.0.jar"
}


resource "aws_lambda_function" "lambda_aws_cli" {
  
  filename                  = local.lambda_payload_filename
  
  function_name             = "casestudylambda"
  role                      = "arn:aws:iam::273859233498:role/LabRole"
  handler                   = "main.java.ch.fhnw.pcls.Handler"
  runtime                   = "java11"
  memory_size               = 512

  source_code_hash          = "${base64sha256(filebase64(local.lambda_payload_filename))}"

  depends_on = [
    aws_cloudwatch_log_group.aws_cli_log_group,
    null_resource.build
  ]

  tags = var.tags 
}

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

resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.lambda_aws_cli.function_name
  authorization_type = "NONE"
  depends_on = [aws_lambda_function.lambda_aws_cli]
}

# API Gateway
resource "aws_api_gateway_rest_api" "api_gateway_lambda" {
  name        = "DivisionLambdaAPIGateway"
  description = "API Gateway to trigger the lambda function"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_aws_cli.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.api_gateway_lambda.execution_arn}/*/*"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_lambda.id}"
  parent_id   = "${aws_api_gateway_rest_api.api_gateway_lambda.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway_lambda.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_lambda.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda_aws_cli.invoke_arn}"
}


resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway_lambda.id}"
  resource_id   = "${aws_api_gateway_rest_api.api_gateway_lambda.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_lambda.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda_aws_cli.invoke_arn}"
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_lambda" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_lambda.id}"
  stage_name  = "prod"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.api_gateway_deployment_lambda.invoke_url}"
}