provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0abc"
  instance_type = "m5.2xlarge"
}

resource "aws_db_instance" "orders" {
  engine         = "mysql"
  instance_class = "db.r5.2xlarge"
}

resource "aws_db_instance" "reports" {
  engine         = "postgres"
  instance_class = "db.r5.xlarge"
}

resource "aws_ebs_volume" "scratch" {
  availability_zone = "us-east-1a"
  type              = "gp2"
  size              = 100
}

