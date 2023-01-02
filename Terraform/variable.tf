variable "aws_access_key" {
  default = "ASIA5LYPBMGPU2IV3U5B"
}
variable "aws_secret_key" {
  default = "SJQeU4JzjpVAvL/uhM0yJNq1Zy5wZvqrElTbbfhw"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEIT//////////wEaDJ9WLn5EItHh5quoUSK/AWx0nTbxOT6eHNDJueikn6UP1d5nmnT3ysVoVZNlQeoml71JIFJI/3ui73EuVUiuG9vY64O7oWGFl/Q3O3yHJVtA6mwBd4eNiduh06TTBfuHfT9rc2Lhch/HvVtunaJ/2V95FwYIsC/Eg2RDe0+eHMJ/tOFf7ecJ+usAtVJeFXFjbNAaj6/AlIDIpTE0rEKwXEKiF4CumIeFTtHIAUAeyF0bx+qfHLZ59i71REBuEWe+rTX5seTCTUjZmXnv9eQEKM/Zyp0GMi3OdKO9PiabIOLVy7q6jb5joGSbu93r1giydDIdrSWUjpH78TcHCE83fJNjqT0="
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