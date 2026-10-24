# Throwaway Nimbiq PR-bot test. Never merged. Not real infrastructure.
resource "aws_db_instance" "nimbiq_test_mysql" {
  identifier                  = "nimbiq-test-mysql"
  engine                      = "mysql"
  instance_class              = "db.r5.2xlarge"
  allocated_storage           = 20
  username                    = "nimbiq_test"
  manage_master_user_password = true
  skip_final_snapshot         = true
}

resource "aws_db_instance" "nimbiq_test_postgres" {
  identifier                  = "nimbiq-test-postgres"
  engine                      = "postgres"
  instance_class              = "db.r5.2xlarge"
  allocated_storage           = 20
  username                    = "nimbiq_test"
  manage_master_user_password = true
  skip_final_snapshot         = true
}
