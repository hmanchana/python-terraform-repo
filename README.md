I am creating my First Terraform Project

Step 1 : Created seperate terraform-bootstrap folder to provision remote backend infrastructure before using it in my main terraform project.
> provider.tf - Which contains the details of cloud provider,version and region by reading this file terraform understands and downloads aws plugins then translate Terraform configuration into aws api calls.
> s3.tf : By Reading this file terraform creates s3 bucket and enabled versioning to maintain previous state files versions then To protect the data enabled the encryption.
> DynamoDB : Terraform reads this file and create the Dynamo DB table. mentioned billing mode as pay per request and partition keys as LOCK ID for terraform.

Step 2 : In the main terraform project created backend.tf
> backend.tf - Here we give the bucket name where state files need to be stored remotely and refer the Dynamo DB table for terraform state locking.

Step 3 : Run below commands to create seperate statefiles for each environment we use workspace 
>terraform workspace new dev
>terraform workspace new prod

Step 4 : As Terraform consider each folder as seperate project need to create provider.tf again and create dev.tfvars,prod.tfvars,main.tf,variables.tf
> provider.tf - Which contains the details of cloud provider,version and region by reading this file terraform understands and downloads aws plugins then translate Terraform configuration into aws api calls.
> variables.tf - Here we will be parametarizing the variables.
> dev.tfvars & prod.tfvars - Pass the values to the variables parametarized






