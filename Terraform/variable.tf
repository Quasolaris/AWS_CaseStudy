variable "aws_access_key" {

  default = "ASIA5LYPBMGP3KDVQHYM"
}
variable "aws_secret_key" {
  default = "xw84sw3guklahsT6qOLc0BF5+sPW+tNfKvnjTeP/"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEPr//////////wEaDM015I8sGY1tDQ5IYSK/AQ+9tt0uIyIddMt9nITZrGTAAl5sQvRbFry7azBEGuMSzmyfoQclGs96BFzN6E7B7+JEUhJwrHSvTKB2IeLr2nBIAQEdjetbefVnsJSMNJ8d+JxHkducPKCt8jBSBhHNeDAnTv/fKWcqLA7lnyaJwFu5y3lvxLK2Jm/uCtzVZ+KHGXpXbfYv9nxpdt1cyZQs/HTx8YBZikTvWiqYpklEhuL8y4tsHBL8WRv/XUf1by6K2HKSw/WSvLNFsjHsvqbfKP/c5J0GMi0l+DszFyST032UJpmmdkQkbK87Aago32DbI6ZZb9Nt1C2ynZILW4KXFLdTH5c="

}

variable "account_id" {
  default = "918617678239"
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
  default = "s3-static-webpage-casestudy-fhnw-new"
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