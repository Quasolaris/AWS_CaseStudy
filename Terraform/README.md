# Terraform Dateien
## main.tf
Deploys infrastructure on AWS:
* CloudFront CDN
* LoadBalancer
* S3 Bucket
* Lambda function
* CloudWatch log group


## deployment
Precondition: Terraform is installed on your machine.

1. Edit the file called variable.tf which contains the following:

```terraform
variable "aws_access_key" {
    default = "<your_aws_access_key_id>"
}
variable "aws_secret_key" {
    default = "<your_aws_secret_access_key>"
}
variable "aws_session_token" {
    default = "<your_aws_session_token>"
}
variable "region" {
    default = "<your_aws_default_region>"
}
```

2. Initialize the working directory:
`terraform init`

3. Verify the script:
`terraform plan`

4. Roll out the configured infrastructure:
`terraform apply`

5. Remove the configured infrastructure:
`terraform destroy`

### Activate HTTPS LoadBalancer
You need to comment in the marked lines in the main.tf file and also comment in the following:

Under loadbalancer ressource in main.tf
````terraform
  depends_on = [
    module.s3,
    # comment the fhnw_cert if already run once
    aws_iam_server_certificate.fhnw_cert
  ]
````

## usage of the lambda function
To test the lambda function you can provide a JSON array with two integers in it:
```JSON
[
    15,
    3
]
```
The function will perform an integer division and return the result.
However, the calculation is currently outcommented.
Instead the function will return the following String: Resultat einfuegen
