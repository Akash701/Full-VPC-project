resource "aws_db_instance" "analytics" {
  identifier        = "analytics-db"
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.r5.2xlarge"
  allocated_storage = 100
  username          = "admin"
  password          = "changeme"
  skip_final_snapshot = true
}
