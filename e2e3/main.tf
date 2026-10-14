resource "aws_cloudwatch_log_group" "bare" {
  name = "/e2e/bare"
}

resource "aws_db_instance" "priced" {
  identifier     = "nimbiq-e2e-suggest"
  engine         = "mysql"
  instance_class = "db.r5.2xlarge"
}

resource "aws_ebs_volume" "old" {
  availability_zone = "us-east-1a"
  size              = 100
  type              = "gp2"
}
