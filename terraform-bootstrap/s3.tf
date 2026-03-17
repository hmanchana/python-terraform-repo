#creation of s3 bucket
resource "aws_s3_bucket" "state" {
  bucket = "python-state-s3-bucket"
  tags = {
    Name = "Terraform State Bucket"
  }
}

#Enabling the version for the s3 bucket so it can store previous versions of state file also
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

#By default encryption is enabled to encrypt the details stored in bucket and decrypted while accessed
#Encryption helps to Certain internal AWS risks & Physical storage exposure
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}