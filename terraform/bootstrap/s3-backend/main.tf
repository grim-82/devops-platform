module "app_bucket" {
  source      = "../../modules/s3-bucket"
  bucket_name = var.bucket_name

  enable_versioning   = true
  enable_encryption   = true
  block_public_access = true
}
