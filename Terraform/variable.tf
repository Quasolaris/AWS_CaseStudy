variable "aws_access_key" {
  default = "ASIAT7Q2II3NJ3UL44FE"
}
variable "aws_secret_key" {
  default = "w08ANSTxjYu6iGP5CjBqV1RKFqsLy6Zsgwv4g1pb"
}
variable "aws_session_token" {
  default = "FwoGZXIvYXdzEIn//////////wEaDJOCStcBRL+Pm4PBhCLCAd+hks+WwgjnPWuoSf0IOsPSYPUPLXZudxO2WfjkXqmJ/PI0EpGHH9Iw6PeORd+X6fEdAFiGD0iunZve6Y56pqZPGtkBJvTtnHlWcZdUMLG/6lWenQDyCy68BuiqLXCKfSsWJCkfZRqcOdsijyT4S3RBTW+hCsLTqm+OZ2aNAiu7B6ajVNC8ISPFtnUu4jct6IG6vKhz6Av0zao81aTsLZCOGySrA7v/omQGIXGagTiao0bEYEK+NcwgJSYFSqqv/0/+KIaAzJ0GMi2M2imvz8UF+ky2AWg6rfTkHi+9tWGS6z7LKrTUB5tWKPQ7eI9C37nDdR8JsoQ="
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