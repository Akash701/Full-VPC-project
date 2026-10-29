provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app" {
  instance_type = "m5.2xlarge"
}

resource "aws_db_instance" "orders" {
  engine         = "mysql"
  instance_class = "db.r5.2xlarge"
}

