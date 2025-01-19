data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
