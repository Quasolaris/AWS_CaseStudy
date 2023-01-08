variable "aws_access_key" {

  default = "ASIASE77BEYKTQRR5ZG5"
}
variable "aws_secret_key" {
  default = "YjAUYUZKT06vKusiUfMVNA48kFbTyZSmqhz0WPHk"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEAUaDJJRDVafLn1brzqPkCK+ASqkY30QfM/ukTOCJ4lcP1LHLKYSCXf8gIGJbwkK8DCiieoUXflj49YSdbuJCer3Cd3QlfaJljPKFK+QH+g24tt5RxLA6oZS9GshTr7ecX+N+xSy7wxBFu6TZCe4wXEQsTI+XDRUsdsfyxE04qrQiRk2toF04Uy+5uGY643WKkLvKHkgC8EyqkBNEYyBRTD7Rrh5BMTnz5KxmT5aHHpUI3KgE8vMSoDm88Tn021BhqHue2BkTRxgy/Z4WbKVNWMouJ3nnQYyLR/6qGjuZYvCX0Lz8Qh49NR5ypzzVCOt4NyG0pTtPMjqLGJ3WlE8bK6ekwOh9g=="

}

variable "account_id" {
  default = "148174349845"
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
  default = "s3-static-webpage-casestudy-fhnw-ik"
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