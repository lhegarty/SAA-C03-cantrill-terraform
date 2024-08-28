terraform {
  backend "s3" {
    bucket  = "management-account-state-bucket"
    key     = "first-s3.tfstate"
    encrypt = true
  }
}
