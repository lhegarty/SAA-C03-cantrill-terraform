data "aws_iam_policy" "administrator_access" {
  name = "AdministratorAccess"
}

data "aws_caller_identity" "current" {}