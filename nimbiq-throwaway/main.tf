provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "fleet" {
  count         = 3
  ami           = "ami-0abc"
  instance_type = "m5.xlarge"
}

resource "aws_instance" "small" {
  ami           = "ami-0abc"
  instance_type = "m5.large"
}

resource "aws_instance" "apps" {
  for_each      = { web = 1, api = 2 }
  ami           = "ami-0abc"
  instance_type = "t3.micro"
}
