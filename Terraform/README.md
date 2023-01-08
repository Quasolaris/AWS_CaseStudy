# Terraform Dateien
## main.tf
Deploys infrastructure on AWS:
* CloudFront CDN
* LoadBalancer
* S3 Bucket
* API Gateway
* Lambda function
* CloudWatch


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
variable "account_id" {
  default = "<your_aws_account_id>"
}
variable "region" {
    default = "<your_aws_default_region>"
}

variable "emailaddress" {
  description = "Email address for the SNS notifications"
  default = "<your_email_address>"
}
```

2. Initialize the working directory:
`terraform init`

3. Verify the script:
`terraform plan`

4. Roll out the configured infrastructure:
`terraform apply`

5. Replace the API Gateway URL in "../S3/webpage/index.html" with the correct (newly deployed) API Gateway URL (example value for <ADD_AWS_API_GATEWAY_URL>: "https://6ruy3crqle.execute-api.us-east-1.amazonaws.com/test/trigger") and then upload/replace the file on S3:
```JS
xmlhttp = new XMLHttpRequest();
            xmlhttp.open("POST", "<ADD_AWS_API_GATEWAY_URL>", true);
            //xmlhttp.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            //xmlhttp.setRequestHeader('Access-Control-Allow-Methods', '*');
            //xmlhttp.setRequestHeader('Access-Control-Allow-Origin', '*');
            //xmlhttp.setRequestHeader('Access-Control-Allow-Max-Age', '32000');
            xmlhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
            //xmlhttp.setRequestHeader('Access-Control-Allow-Headers', '*');
            xmlhttp.send(JSON.stringify(arguments));
```

7. Remove the configured infrastructure again:
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
