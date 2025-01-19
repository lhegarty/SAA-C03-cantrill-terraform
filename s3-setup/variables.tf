variable "region" {
  type    = string
  default = "us-east-1"
}

variable "keybase_account" {
  type = string
}

variable "account_alias" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "key_pair_name" {
  type    = string
  default = "placeholder-keypair"
}

