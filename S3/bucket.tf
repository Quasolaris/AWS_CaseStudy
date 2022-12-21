
resource "aws_s3_bucket" "som-s3-bucket-tf" {
    bucket = "${var.bucket_name}" 
    acl = "${var.acl_value}"   
}

resource "aws_s3_access_point" "limesurvey_access_point" {
    bucket = "${var.bucket_name}"
    name   = "limesurvey"

    depends_on = [
        aws_s3_bucket.som-s3-bucket-tf
    ]
}
