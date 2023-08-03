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

### Setup Keybase

- Install Keybase
- `keybase pgp gen`
- Follow prompts

### TF Vars

- Rename `iam.auto.tfvars.example` to `iam.auto.tfvars` and add your own values to the variables.

- run `terraform init`
- plan and apply

### To Decrypt Password and Secret Key after terraform apply

### For password..

- `terraform output -raw password | base64 --decode | keybase pgp decrypt`

### For secret key..

- `terraform output -raw secret_access_key | base64 --decode | keybase pgp decrypt`

### Delete credentials from root account.

### Login to your new admin account

- https://YOUR_ACCOUNT_ALIAS.signin.aws.amazon.com/console/
- Username: IAMADMIN
- Password: Password from above.
