terraform {
  backend "s3" {
    bucket  = "management-account-state-bucket"
    key     = "first-ec2.tfstate"
    encrypt = true
  }
}
