variable "aws_access_key" {

  default = "ASIA5LYPBMGP2NLILEIC"
}
variable "aws_secret_key" {
  default = "6xRpZcl/GQC0KW8aTLHjH0bx0DnCDJaj/YZR2SRb"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEAIaDJYV5RSAQmFxjTah0CK/AfGW+nm+xwy0UgtjnP7fEJtd1oA5BdfsbY/LaSl4EqJVsEV0Ls0cKXA8TEcmmGYAn8BFA8/Cuh2DuqdQebO2GPTGcBPgDfkhrsocmd/0wZhrRQuOELj78XhRPOWwx28NuQXTS+d353ueRXRZIpWAlb9Baf+84VBIaEJ4lrDQmEkY5OtDowXkmb6SIb8oZ3PuXInOu4KVq+FM+H5DKfia9nZzud6pVuTK6idsOTyWiG5dR+AYAvVWzpEjSE7V4PJ5KIe95p0GMi05pesG78CVMfpRzizIsjaSoYMhdVEZilPJ65I91QHtBUTxCqRMCpt0x8Wqfso="
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