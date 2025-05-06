variable "aws_region" {
  default = "us-east-1"
}

variable "aws_availability_zone" {
  default = "us-east-1a"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  
}

variable "public_subnet_cidr_block" {
  default = "10.0.10.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.20.0/24"
}

variable "aws_route_table_cidr_block" {
  default = "0.0.0.0/0"
}