resource "aws_s3_bucket" "tf_state" {
  bucket = "my-tf-state-bucket"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true
    expiration {
      days = 30
    }
    prefix = "log/"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
