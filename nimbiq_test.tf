resource "aws_lambda_function" "api" {
  function_name = "my-api"
  timeout       = 900
  memory_size   = 3008
  runtime       = "python3.12"
  handler       = "handler.main"
}

resource "aws_nat_gateway" "main" {
  allocation_id = "eip-123"
  subnet_id     = "subnet-123"
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name = "/aws/lambda/my-api"
}

resource "aws_instance" "app" {
  ami           = "ami-123"
  instance_type = "t2.2xlarge"
}
# nimbiq test trigger
# trigger v2
