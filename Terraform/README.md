# Terraform Dateien
## main.tf
Deploys infrastructure on AWS:
* Lambda function


## deployment
Precondition: Terraform is installed on your machine.

1. Build the Java application with maven

```Shell
cd ../Lambda
mvn package
```

2. Create a file called variable.tf which contains the following:

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

3. Initialize the working directory:
`terraform init`

4. Verify the script:
`terraform plan -out .tfpan`

5. Roll out the configured infrastructure:
`terraform apply .tfplan`

6. Remove the configured infrastructure:
`terraform destroy`
### Activate HTTPS LoadBalancer
YOu need to comment in the marked lines in the main.tf file and also comment in the following:

Under loadbalancer ressource in main.tf
````terraform
  depends_on = [
    module.s3,
    # comment the fhnw_cert if already run once
    aws_iam_server_certificate.fhnw_cert
  ]
````
### Troubleshooting
In case you see the following error during the deployment (`terraform apply`):
```
Error: Provider produced inconsistent final plan
│
│ When expanding the plan for aws_lambda_function.lambda_aws_cli to include new values learned so far during apply, provider "registry.terraform.io/hashicorp/aws" produced an invalid new value for
│ .source_code_hash: was cty.StringVal("u2jmP8yRUZSG71hntgWqx8b8/dq6k05ZTqinr48iZTw="), but now cty.StringVal("VO4rwLNJ4viztxkwhQVwmh//9DU0iJQK3AjrPVqtKkk=").
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
```

Open the file called main.tf and increase the version number in the following code block:

```terraform
data "template_file" "pom_template" {

  template = file("../Lambda/templates/pom.tpl")
  
  vars = {
    artifact      = "casestudylambda"
    version       = "1.0" # change version number in order to redeploy the function
    description   = "case-study-lambda Lambda Function"
  }
}
```
## usage of the lambda function
To test the lambda function you can provide a JSON array with two integers in it:
```JSON
[
    15,
    3
]
```
The function will perform an integer division and return the result.
