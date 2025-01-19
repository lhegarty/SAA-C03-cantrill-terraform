################
# Create Group #
################

resource "aws_iam_group" "administrators" {
  name = "Administrators"
  path = "/"
}

################################
# Enable MFA & Password Policy #
################################

module "enforce_mfa" {
  source                          = "terraform-module/enforce-mfa/aws"
  version                         = "~> 1.0"
  policy_name                     = "managed-mfa-enforce"
  account_id                      = data.aws_caller_identity.current.id
  groups                          = [aws_iam_group.administrators.name]
  manage_own_signing_certificates = true
  manage_own_ssh_public_keys      = true
  manage_own_git_credentials      = true
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}


##########################
# Attach Policy To Group #
##########################

resource "aws_iam_group_policy_attachment" "administrators" {
  group      = aws_iam_group.administrators.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

###################
# Define PGP Key  #
###################

data "local_file" "pgp_key" {
  filename = abspath("./public-key-binary.gpg")
}

###############
# Create User #
###############

resource "aws_iam_user" "administrator" {
  name = "IAMADMIN"
}

resource "aws_iam_account_alias" "main" {
  account_alias = var.account_alias
}


resource "aws_iam_user_login_profile" "administrator" {
  user                    = aws_iam_user.administrator.name
  password_reset_required = true
  pgp_key                 = data.local_file.pgp_key.content_base64
}

resource "aws_iam_access_key" "user_access_key" {
  user    = aws_iam_user.administrator.name
  pgp_key = data.local_file.pgp_key.content_base64
}

######################## 
# Attach User To Group #
########################

resource "aws_iam_user_group_membership" "administrator" {
  user   = aws_iam_user.administrator.name
  groups = [aws_iam_group.administrators.name]
}

########################
#   Output User Creds  #
########################

output "password" {
  value     = aws_iam_user_login_profile.administrator.encrypted_password
  sensitive = true
}

output "access_key_id" {
  value = aws_iam_access_key.user_access_key.id
}

output "secret_access_key" {
  value = aws_iam_access_key.user_access_key.encrypted_secret
}

output "login_url" {
  value = "https://${var.account_alias}.signin.aws.amazon.com/console"
}

