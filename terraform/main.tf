module "app_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = var.bucket_name
}

