output "bucket_name" {
  description = "Name of the created AWS S3 bucket"
  value       = module.app_bucket.bucket_name
}

output "versioning_enabled" {
  description = "Whether S3 bucket versioning is enabled"
  value       = module.app_bucket.versioning_enabled
}

output "encryption_enabled" {
  description = "Whether server-side encryption is enabled"
  value       = module.app_bucket.encryption_enabled
}

output "public_access_blocked" {
  description = "Whether public access is blocked"
  value       = module.app_bucket.public_access_blocked
}
