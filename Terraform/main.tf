provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    token = "${var.aws_session_token}"
    region = "${var.region}"
}

#module "s3" {
#    source = "../S3"
    #bucket name should be unique
#    bucket_name = "som-s3-bucket-tf-case-study-umfrage-tool"       
#}

module "ecs" {
    source = "../ECS"  
}