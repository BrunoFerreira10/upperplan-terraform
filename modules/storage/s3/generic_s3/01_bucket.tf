resource "aws_s3_bucket" "project_files" {
  bucket = var.project_bucket_name
}

resource "aws_s3_bucket_versioning" "project_files" {
  bucket = aws_s3_bucket.project_files.id

  versioning_configuration {
    status = "Enabled"
  }
}