resource "aws_db_instance" "priced" {
  identifier     = "nimbiq-e2e-headline"
  engine         = "mysql"
  instance_class = "db.r5.2xlarge"
}

resource "aws_s3_bucket" "bare" {
  bucket = "nimbiq-e2e-headline-bare"
}
