
resource "aws_s3_bucket" "webpage_bucket_casestudy_fhnw" {
    bucket = "${var.bucket_name}"
    acl = "${var.acl_value}"
}

resource "aws_s3_object" "file_upload" {
    bucket      =  "${var.bucket_name}"
    key         =  "index.html"
    source      =  "${path.module}/webpage/index.html"

    depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}

resource "aws_s3_bucket_website_configuration" "case_study_webpage_fhnw" {
    bucket =  "${var.bucket_name}"

    index_document {
        suffix = "index.html"
    }
    depends_on = [aws_s3_object.file_upload]
}

resource "aws_s3_access_point" "s3_accesspoint_fhnw_pcls" {
    bucket = "${var.bucket_name}"
    name   = "lambdavaluespage"

    depends_on = [aws_s3_bucket.webpage_bucket_casestudy_fhnw]
}