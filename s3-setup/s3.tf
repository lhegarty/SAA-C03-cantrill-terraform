resource "aws_s3_bucket" "koala_bucket" {
  bucket = "koalacampaign19191919"
  acl    = "private"

  tags = {
    Name        = "koalacampaign"
    Environment = "management"
  }
}