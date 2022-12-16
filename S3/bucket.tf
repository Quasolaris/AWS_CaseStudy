resource "aws_s3_bucket" "som-s3-bucket-tf" {
    bucket = "${var.bucket_name}" 
    acl = "${var.acl_value}"   
}