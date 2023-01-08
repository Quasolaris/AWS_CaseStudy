variable "aws_access_key" {

  default = "ASIAT7Q2II3NLRIEIL4B"
}
variable "aws_secret_key" {
  default = "m4DQM7LCSGcajUB79ifCPH2sfrg6IYjloUdRPWrv"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEBQaDLHaptNOjbVYT0/8SiLCAUdYZHir+TbLufX5sJiTnB/3cwpjQSYnKQBJoAuRPq90VvA/Rhf9t4z8GXncgctB4oqp7yz6g/LEhkc5gf4ZWKE1KUwcF1rnSeWkAiiUlfqCtNlpjMWPHGV8gaXEvNKfOSMV2NOL1F4Pl2CxoNbOvUXGgOXBtHFPzAVy5oCcnaPeit6cOgoM/cyQlKY1Tv/xWV4U583J9Ups0gSVWqOhJ9yzsqqrGtLBJozYWyBmpbZjfbqSfBFpMlSn26VKzEa5AEY7KOG96p0GMi37GnjkNqcaQMatWqAtkb0tqldzSIh/xoLwxOUrkfFg5bPTzLoEwr8pZT9PlC8="

}

variable "account_id" {
  default = "273859233498"
}


variable "region" {
  default = "us-east-1"
}


# lambda function variables
variable tags {
  description     = "Tag list"
  type            = map(any)
  default = {
    "module": "pcls",
    "assignment": "casestudy"
  }
}

# variable names for build script

variable "s3Bucket" {
  default = "s3-static-webpage-casestudy-fhnw-som"
}

variable "laodbalancer" {
  default = "staticwebpageloadbalancer"
}

variable "lambdaname" {
  default = "casestudylambda"
}

variable "acl_value" {
  default = "private"
}

variable "sns_name" {
  default = "casestudy-sns"
}

variable "emailaddress" {
  description = "Email address for the SNS notifications"
  default = "aws@punraz.ch"
}