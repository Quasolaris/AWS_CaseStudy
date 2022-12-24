provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    token = "${var.aws_session_token}"
    region = "${var.region}"
}

module "ecr" {
    source = "../ECR"
}

#module "s3" {
#    source = "../S3"
#    bucket_name = "som-s3-bucket-tf-case-study-umfrage-tool"
#}

#module "rds" {
#    source = "../RDS"
#}

#module "ecs" {
#    source = "../ECS"  
#}

#module "cdn" {
#    source = "../CDN"
#}

