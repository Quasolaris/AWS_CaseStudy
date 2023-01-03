variable "aws_access_key" {
  default = "ASIA5LYPBMGP2NBCMSE6"
}
variable "aws_secret_key" {
  default = "v6fJDXNvoGdPJS864Dv7Q0/XNEwuuKhyLNnbqpr/"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEKD//////////wEaDJwSjQ0xZFHvMOJZNSK/ATLNchSL0ao4sHNGbAGmly8jSRS+KX7ivih771zCZBMw897vajeLxdjKWbflbOqenZYfJ4RazseglYstozU+xtHvC1EQ6PuQwqArs6rffVQ4BhFaaUKESYf2BRtdXy4AsXXdMkSjRLgoWsjoZiHoC9i2Agf+ktxVMkQUsnlamm8ot55TmxAVPJ9R62gD3iu7rFyy4USoUDoSnls0UlEw/sO2uykAtkyezkzaT64VI5AGc0YyTvyG1pQTUpyuduAmKKHz0J0GMi1Wh5c/mm7XPrWrXFtGLwSOb8SyW9/Q6S7bRorUNtaVlR4G4ARKbD4g+v2+LeE="
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
