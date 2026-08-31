# Throwaway resource for Nimbiq pricing-consistency demo dry-run.
# Not applied/provisioned — PR is for pricing comment verification only.
resource "aws_db_instance" "demo_pricing_check" {
  identifier        = "demo-pricing-check"
  engine            = "postgres"
  instance_class    = "db.r5.2xlarge"
  allocated_storage = 100
}
