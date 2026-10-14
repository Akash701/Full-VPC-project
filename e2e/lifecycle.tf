# Pre-existing file (unchanged by the PR): lifecycle config for the "covered" bucket.
resource "aws_s3_bucket_lifecycle_configuration" "covered" {
  bucket = aws_s3_bucket.covered.id
  rule {
    id     = "archive"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
