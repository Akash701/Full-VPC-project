provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "brace_web" {
  ami           = "ami-0123456789abcdef0"
  instance_type = "m5.xlarge" # sized for peak {
  // or_statement {
}

resource "aws_instance" "brace_app" {
  ami           = "ami-0123456789abcdef0"
  instance_type = "m5.2xlarge"
}
