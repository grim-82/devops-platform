output "bucket_name" {
  description = "Name of the S3 bucket"
  value = module.app_bucket.bucket_name
}
