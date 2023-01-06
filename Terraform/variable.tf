variable "aws_access_key" {

  default = "ASIAT7Q2II3NH6V7E45M"
}
variable "aws_secret_key" {
  default = "RoPl9INMDoxoWraX4k6Qob85B0ptdw4nu5ZZ+7tv"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEOr//////////wEaDNnL5n1MUU3sX3Oh9yLCAbpO3HrcgGfrvEgSUzv9jPiPwkz6FuPlYR0E62N+IVYxg+izss2HhD8PBSIn/b66/2sdPtI9X1avTHg0zo6DN5KpSIYooo+5LCVOwW5KJ7tAiEPlvNvgJSI+O+Sdb5OnqfteHkKIv9yTqjqoHfx22/rPu7W5todCJUOG+3RftPClGIAnvmSKRvAmNygUQGt//mHU6iQYSJpQ28LxaExBpOZoMKvhWSTzU+vXAkm39fpVvEhwOWbtZCH1vUPHR66rV3qWKOud4Z0GMi2Sv/csNdJiOJDjjWivvjvPcot8QYDS5lbPjIvH5gQP3Hf0ef05wncsW99j2YU="

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
