
resource "aws_s3_bucket" "webpage_bucket_casestudy_fhnw" {
    bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_acl" "webpage_bucket_casestudy_acl" {
  bucket = aws_s3_bucket.webpage_bucket_casestudy_fhnw.id
  acl    = "${var.acl_value}"
}

resource "aws_s3_object" "file_upload_index" {
    bucket      =  "${var.bucket_name}"
    key         =  "index.html"
    acl         = "public-read"
    source      =  "${path.module}/webpage/index.html"
    content_type = "text/html"

    depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}


resource "aws_s3_object" "file_upload_error" {
    bucket      =  "${var.bucket_name}"
    key         =  "error.html"
    acl         = "public-read"
    source      =  "${path.module}/webpage/error.html"
    content_type = "text/html"

    depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}



resource "aws_s3_bucket_website_configuration" "case_study_webpage_fhnw" {
    bucket =  "${var.bucket_name}"

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
    bucket =  "${var.bucket_name}"
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
                 "arn:aws:s3:::${var.bucket_name}/*"
              ]
          }
        ]
    }
    POLICY
    depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}

resource "aws_s3_access_point" "s3_accesspoint_fhnw_pcls" {
    bucket = "${var.bucket_name}"
    name   = "lambdavaluespage"

    depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}