provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "rot" {
  ami           = "ami-0abc"
  instance_type = "m5.xlarge"
}
