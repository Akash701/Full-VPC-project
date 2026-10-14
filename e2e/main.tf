resource "aws_cloudwatch_log_group" "log_ok" {
  name              = "/e2e/ok"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "log_bare" {
  name = "/e2e/bare"
}

resource "aws_s3_bucket" "covered" {
  bucket = "nimbiq-e2e-covered"
}

resource "aws_s3_bucket" "bare" {
  bucket = "nimbiq-e2e-bare"
}
