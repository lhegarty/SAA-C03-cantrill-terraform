### Add root account credentials to your .aws/credentials file and ensure $AWS_PROFILE has assumed.
- Can also use the following alias

```
  awsume() {
    export AWS_PROFILE=$1
  }
```

- `aws sts get-caller-identity` can confirm you have assumed the correct account.

### Create s3 bucket manually via cli for state file to be encrypted at rest.

- `aws s3 mb s3://YOUR_BUCKET_NAME --region YOUR_REGION`
- `aws s3api put-bucket-versioning --bucket YOUR_BUCKET_NAME --versioning-configuration Status=Enabled`
- `aws s3api put-bucket-encryption --bucket YOUR_BUCKET_NAME --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'`

- Configure the backend.tf file to point to your bucket.

### TF Vars

- Rename `iam.auto.tfvars.example` to `iam.auto.tfvars` and add your own values to the variables.

- run `terraform init`
- plan and apply

### To Decrypt Password and Secret Key after terraform apply

### For password..(there is an alternative)

- `terraform output -raw password | base64 --decode | keybase pgp decrypt`

### For secret key.. (there is an alternative)

- `terraform output -raw secret_access_key | base64 --decode | keybase pgp decrypt`

### Delete credentials from root account.

### Login to your new admin account

- https://YOUR_ACCOUNT_ALIAS.signin.aws.amazon.com/console/
- Username: IAMADMIN
- Password: Password from above.

########################

An alternative answer that avoids using Keybase entirely, is by generating your own PGP keys for encryption. This is convenient if your organization does not use Keybase and / or you don't want to create a Keybase account.

There is a wonderful blog post here that breaks down most of the steps, but to simplify:

Create your PGP key locally:

#### confirm you have pgp installed, check for existing keys
`gpg -k`

#### create a new key
#### IMPORTANT: with your real name, email, and optionally a passphrase
`gpg --gen-key`

#### export your key for the email used
`gpg --output public-key-binary.gpg --export <YOUR_EMAIL>@<X.DOMAIN.com>`
`Setup a reference for your AWS IAM resource aws_iam_access_key per the Terraform documentation here`

```
data "local_file" "pgp_key" {
  filename = abspath("./relative/path/to/your/public-key-binary.gpg")
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
  pgp_key = data.local_file.pgp_key.content_base64
}

output "password" {
  value = aws_iam_access_key.lb.encrypted_secret
}
```

Proceed to terraform init, validate, plan, and apply when you are ready to deploy for IaC

Post deployment of your IAM user, you can decrypt the sensitive secret_key using the following command:

terraform output -raw password | base64 --decode | gpg --decrypt --pinentry-mode=loopback
Skip the --pinentry-mode=loopback flag if you did not set a passphrase on PGP key generation

may need to use `export GPG_TTY=$(tty)` to set gpg to expect input from the standard terminal.

This will need doing with the secret_access_key as well