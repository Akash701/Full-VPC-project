resource "aws_db_instance" "nimbiq_pricing_verify" {
  identifier          = "nimbiq-pricing-verify-test"
  engine              = "postgres"
  instance_class      = "db.r5.2xlarge"
  allocated_storage   = 20
  skip_final_snapshot = true
}
