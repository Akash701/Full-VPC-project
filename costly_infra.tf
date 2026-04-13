resource "aws_lambda_function" "expensive_fn" {
  function_name = "expensive-processor"
  runtime       = "python3.11"
  handler       = "handler.main"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "handler.zip"

  timeout     = 900
  memory_size = 3008
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main-nat-gateway"
  }
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name = "/app/expensive-processor"
  # no retention_in_days set — logs accumulate forever
}

resource "aws_instance" "heavy_worker" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.2xlarge"

  tags = {
    Name = "heavy-worker"
  }
}
