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

cat > infra/main.tf << 'EOF'
# Production infrastructure — intentionally over-provisioned

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ISSUE 1: RDS — massively oversized
# db.r5.2xlarge = $700.80/mo
# Should be db.t3.medium = $25/mo
resource "aws_db_instance" "production" {
  identifier        = "prod-database"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.r5.2xlarge"
  allocated_storage = 500
  multi_az          = true
  storage_type      = "io1"
  iops              = 3000
  db_name           = "appdb"
  username          = "admin"
  password          = "change-me-123"
  skip_final_snapshot = false
}

# ISSUE 2: Three NAT Gateways
# $32.85/mo each = $98.55/mo total
# One is usually enough for non-prod
resource "aws_nat_gateway" "az1" {
  allocation_id = aws_eip.az1.id
  subnet_id     = "subnet-abc123"
  tags = { Name = "prod-nat-az1" }
}

resource "aws_nat_gateway" "az2" {
  allocation_id = aws_eip.az2.id
  subnet_id     = "subnet-def456"
  tags = { Name = "prod-nat-az2" }
}

resource "aws_nat_gateway" "az3" {
  allocation_id = aws_eip.az3.id
  subnet_id     = "subnet-ghi789"
  tags = { Name = "prod-nat-az3" }
}

resource "aws_eip" "az1" { domain = "vpc" }
resource "aws_eip" "az2" { domain = "vpc" }
resource "aws_eip" "az3" { domain = "vpc" }

# ISSUE 3: ElastiCache — oversized node
# cache.r6g.large = $150.38/mo
# cache.t3.micro = $12/mo for most session stores
resource "aws_elasticache_cluster" "sessions" {
  cluster_id      = "session-cache"
  engine          = "redis"
  node_type       = "cache.r6g.large"
  num_cache_nodes = 1
  port            = 6379
}

# ISSUE 4: Lambda — 12x over-provisioned memory
# 3008MB at 900s timeout
# Most APIs need 256MB and 30s max
resource "aws_lambda_function" "api" {
  filename      = "api.zip"
  function_name = "prod-api-handler"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  memory_size   = 3008
  timeout       = 900
}

resource "aws_iam_role" "lambda" {
  name = "prod-api-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# ISSUE 5: S3 buckets with no lifecycle policy
# Objects accumulate forever at $0.023/GB/month
resource "aws_s3_bucket" "logs" {
  bucket = "company-application-logs-prod"
}

resource "aws_s3_bucket" "backups" {
  bucket = "company-database-backups-prod"
}

# ISSUE 6: CloudWatch log groups — no retention
# Logs stored forever at $0.03/GB/month
resource "aws_cloudwatch_log_group" "api" {
  name = "/aws/lambda/prod-api-handler"
  # retention_in_days not set
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/app/prod"
  # retention_in_days not set
}
EOF
