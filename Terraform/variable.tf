variable "aws_access_key" {

  default = "ASIAT7Q2II3NPGUJ244T"
}
variable "aws_secret_key" {
  default = "lYqftqmBuwk7VDjoZ7zyYEIJQwJhBR6P00Na+km5"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEO7//////////wEaDByluz9DDouYc59BkCLCAXS/kcxTyQA6jSdW5Nr5vbQsVu09hg0sNAIEtu3wgGdqvk8jFZkxHr49rWZE0+arvOLJ69lTJZSXftXJ6T/WYZovghwqGrdOZ3NRh7Pc2YTlCH6TJ02ytaArBcp/55JCUURmfVj3dPoAySEgAXmX1C9mfHXhrymoQZ4Mc7hFoLj1/Fkm/NwBRLGwGTJWLP0gtGu6TIyhQn2CgYKVT+s6NN9cxTgoXah1SzCpBZi3lcl74h1trvZkBVpMQ/vVGCIhbMrtKL+M4p0GMi0GT+ziFeZBMJj+zU8l08jMOhH8O7KWTXt0apNHlme6mKSNA40zxWbgseiCS6M="

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
  default = "s3-static-webpage-casestudy-fhnw"
}

variable "laodbalancer" {
  default = "staticwebpageloadbalancer"
}

variable "lambdaname" {
  default = "casestudylambda"
}
