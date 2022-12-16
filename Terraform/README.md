# Terraform Dateien
## main.tf
Erstellt einen ECS Cluster, ein ECR Repository, etc.
## usage
Precondition: Terraform is installed on your machine.

1. Create a file called variable.tf which contains the following:

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