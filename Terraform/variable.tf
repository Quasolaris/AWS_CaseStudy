variable "aws_access_key" {
  default = "ASIAT7Q2II3NICDXID53"
}
variable "aws_secret_key" {
  default = "AxJGhDfQeldCODts9JuTctQ2s7Ub/svdZ8flvjLn"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEI7//////////wEaDKcziAs0neeQHoHkhCLCARikHDOmAVYacrH7ok1pDdLip2N8PxPNN+oOBlVcKswUE+hA3wivY5HKzcsYYPgrIwxoPci+Mf/SpreTR+rsQyGWJ5+Kx0NHRlchCcv9rXqZt+JNDoiDmYHDcWgbYlnVM6I4qh4KFXXfSwko2b5tNCswErweVYC5Bo5YvzR/xUDqp3myBaAncUT73esmX0XUr/jfs8EXaYrShRdlEPA2+z88h2YLtUAkPyvLQZnRSrhJhd2K8S7QAOEeQjVwh5xseHnEKLSGzZ0GMi3bW7CWf8d/dt+tbRysjNSWCEOEwJ4uOkTg8hH6xit70zqDNV8luQM9KucCBDo="
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