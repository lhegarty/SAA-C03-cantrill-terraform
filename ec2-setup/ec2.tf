#######################
# Create Private Key  #
#######################

# downside to this approach is that the private key is stored in state, not the end of the world if state 
# is encrypted at rest inside of s3 bucket. Creates a .pem which is macOs compatible

resource "tls_private_key" "A4L_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#######################
# Create SSH Key Pair #
#######################

resource "aws_key_pair" "A4L_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.A4L_private_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.A4L_private_key.private_key_pem}' > ./${var.key_pair_name}.pem"
  }
}

#########################
# Create Security Group #
#########################

resource "aws_security_group" "aws_sg" {
  name = "security group from terraform"

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

###################
# Create Instance #
###################

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "my-first-ec2-instance"

  ami = data.aws_ami.amazon_linux.id

  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.A4L_key_pair.key_name
  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.aws_sg.id]

  tags = {
    Terraform   = "true"
    Environment = "management"
  }
}
