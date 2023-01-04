provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    token = "${var.aws_session_token}"
    region = "${var.region}"
}

resource "aws_lambda_function" "casestudy_lambda_function" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name    = "casestudylambda"
  role             = "arn:aws:iam::273859233498:role/LabRole"
  handler          = "func.handler"
  runtime          = "python3.8"

}

data "archive_file" "zip" {
  type        = "zip"
  source_dir = "${path.module}/lambda/"
  output_path = "${path.module}/packedlambda.zip"
}


resource "aws_lambda_function_url" "casestudy_lambda_url" {
  function_name      = aws_lambda_function.casestudy_lambda_function.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
