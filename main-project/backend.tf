terraform {
  backend "s3" {
    bucket         = "python-state-s3-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
