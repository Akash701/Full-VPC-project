provider "aws" {
  region = "us-east-1"
}

resource "aws_ebs_volume" "scratch" {
  availability_zone = "us-east-1a"
  type              = "gp2"
  size              = 100
}

resource "aws_instance" "worker" {
  ami           = "ami-0abc"
  instance_type = "m5.xlarge"
}
