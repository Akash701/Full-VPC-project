provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "wording_check_ec2" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
}

resource "aws_db_instance" "wording_check_db" {
  identifier     = "wording-check"
  engine         = "mysql"
  instance_class = "db.r5.2xlarge"
  allocated_storage = 100
}

