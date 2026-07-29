variable "db_password" {
  description = "Password for the reporting RDS instance"
  type        = string
  sensitive   = true
}

resource "aws_db_instance" "reporting" {
  identifier          = "reporting-db"
  engine              = "postgres"
  instance_class      = "db.r5.2xlarge"
  allocated_storage   = 100
  username            = "reporting_admin"
  password            = var.db_password
  skip_final_snapshot = true
}
