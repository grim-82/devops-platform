output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "versioning_enabled" {
  description = "Whether S3 bucket versioning is enabled"
  value       = var.enable_versioning
}

output "encryption_enabled" {
  description = "Whether server-side encryption is enabled"
  value       = var.enable_encryption
}

output "public_access_blocked" {
  description = "Whether public access is blocked"
  value       = var.block_public_access
}
