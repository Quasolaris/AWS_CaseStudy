# Not in use for the case study
This directory and the contained files were created for test and demo purposes.
It is currently not used for the case study.
It contains the configuration to deploy an AWS S3 bucket with Terraform.

## SetUp
Upgrade Terraform:
```terraform
terraform init -upgrade
```

Update the POST URL.
Go to your Lambda function inside the dashboard and copy the Function URL. Then replace it in the index.html file:
```html

xmlhttp = new XMLHttpRequest();
xmlhttp.open("POST", "[PASTE URL HERE]", true);
xmlhttp.onreadystatechange = function () { //Call a function when the state changes.
if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
    cb(xmlhttp.responseText);
    }
};
xmlhttp.send(JSON.stringify(arguments));
```
Replace the index.html inside the bucket with the updated one.

Go to the public URL of the bucket and make a request, chekc the network-debugging (F12) of your browser to see if the request works. When you get a Cross-Origin error then the request worked. Now to go the Lambda function and check the logs.