# Initially created with Root account, credentials swapped to admin generated account after creation. Revoke root access keys

### Setup Keybase

- Install Keybase
- `keybase pgp gen`
- Follow prompts

## TF Vars

- Rename `iam.auto.tfvars.example` to `iam.auto.tfvars` and add your own values to the variables.

- run `terraform init`
- plan and apply

### To Decrypt Password and Secret Key after terraform apply

# For password..

- `terraform output -raw password | base64 --decode | keybase pgp decrypt`

# For secret key..

- `terraform output -raw secret_access_key | base64 --decode | keybase pgp decrypt`