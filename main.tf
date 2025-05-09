resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.aws_availability_zone

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr_block   // Create a seperarte variable for this one
  availability_zone = var.aws_availability_zone
  
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_eip" "elastic_nat" {
  domain = "vpc"  
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_nat.id
  subnet_id = aws_subnet.public.id

  tags={
    Name = "main-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route{
    cidr_block = var.aws_route_table_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags={
    Name = "public-rt"
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.aws_route_table_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  
tags = {
  Name = "private-rt"
}

}

resource "aws_route_table_association" "public" {
route_table_id = aws_route_table.public.id
subnet_id = aws_subnet.public.id 

}

resource "aws_route_table_association" "private" {
route_table_id = aws_route_table.public.id
subnet_id = aws_subnet.private.id

}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.main_vpc.id

  ingress{
    description = "SSH from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    description = "Allow all outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

//EC2 instence

resource "aws_instance" "ubuntu_server" {
  ami = data.aws_ssm_parameter.ubuntu_ami.value
 instance_type = "t2.micro"
 subnet_id = aws_subnet.public.id
 vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 key_name = "ec2_key"

 tags={
  Name = "TerraformUbuntuInstence"
 }

}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-second-bucket20251"
  force_destroy = true 


  tags = {
    Name = "myuniquebucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_dynamodb_table" "terrform_dynamo" {
  name = "terraform-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "terraform-lock-table"
  
  }
}

terraform {
  backend "s3" {
    bucket = "my-second-bucket20251"
    key = "envs/dev/networking/vpc.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-dynamo"
    encrypt = true
  }
}