### Creating an instance and connecting via SSH

- `init, plan and apply`
- `chmod 400 placeholder-keypair.pem`
- `ssh -i "placeholder-keypair.pem" ec2-user@ec2-54-89-88-253.compute-1.amazonaws.com` 

The above line will vary based on your instance.

- `chmod 777 placeholder-keypair.pem` to allow another TF apply