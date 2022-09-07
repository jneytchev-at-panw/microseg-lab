resource "aws_flow_log" "flowlog1" {
  log_destination      = aws_s3_bucket.bucket1.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc1.id
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "${var.prefix}-bucket1"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bssec1" {
  bucket = aws_s3_bucket.bucket1.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms1.arn
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "bver1" {
  bucket = aws_s3_bucket.bucket1.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "bpab1" {
  bucket = aws_s3_bucket.bucket1.id
  restrict_public_buckets = true
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
}

resource "aws_kms_key" "kms1" {
  description             = "KMS key 1"
  enable_key_rotation    = true
}