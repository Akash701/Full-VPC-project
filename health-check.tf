resource "aws_db_instance" "production_db" {
  instance_class = "db.r5.2xlarge"
  engine         = "mysql"
  allocated_storage = 500

  backup_retention_period = 35
}

resource "aws_lambda_function" "api" {
  function_name = "api-handler"
  timeout       = 900
  memory_size   = 10240
}
