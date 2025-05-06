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