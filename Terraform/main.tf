provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    token = "${var.aws_session_token}"
    region = "${var.region}"
}

module "s3" {
    source = "../S3"
    bucket_name = "${var.s3Bucket}"
}

#==========================================================
# following is the needed cert creation for HTTPS
/*
resource "tls_private_key" "fhnw_private_casestudy" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

# The error for a missing value can be ignored (new Terraform rule, field is READONLY)
resource "tls_self_signed_cert" "cert_fhnw_casestudy" {

  private_key_pem = tls_private_key.fhnw_private_casestudy.private_key_pem

  subject {
    common_name  = "s3-static-webpage-casestudy-fhnw.s3.amazonaws.com"
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
  name             = "fhnw_cert_1"
  private_key      = tls_private_key.fhnw_private_casestudy.private_key_pem
  certificate_body = tls_self_signed_cert.cert_fhnw_casestudy.cert_pem

  depends_on = [tls_self_signed_cert.cert_fhnw_casestudy]
}
*/
# ==============================================================




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
  /*
  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::918617678239:server-certificate/fhnw_cert_1" #change to your AWS id
  }
  */
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  tags = {
    Name = "loadbalancer-http-8080"
  }

  depends_on = [
    module.s3
    # comment the fhnw_cert if already run once
    #aws_iam_server_certificate.fhnw_cert
  ]
}


#module "cdn" {
#    source = "../CDN"
#}

data "template_file" "pom_template" {

  template = file("../Lambda/templates/pom.tpl")
  
  vars = {
    artifact      = "casestudylambda"
    version       = "1.8" # change version number in order to redeploy the function
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
  
  function_name             = "${var.lambdaname}"
  role                      = "arn:aws:iam::918617678239:role/LabRole"
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