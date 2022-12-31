provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    token = "${var.aws_session_token}"
    region = "${var.region}"
}

#module "s3" {
#    source = "../S3"
#    bucket_name = "som-s3-bucket-tf-case-study-umfrage-tool"
#}

#module "cdn" {
#    source = "../CDN"
#}

data "template_file" "pom_template" {

  template = file("../Lambda/templates/pom.tpl")
  
  vars = {
    artifact      = "casestudylambda"
    version       = "1.0"
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