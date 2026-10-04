resource "aws_s3_bucket" "app" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}





#resource "aws_s3_bucket" "app" {
#  bucket = var.bucket_name
#}

#data "aws_caller_identity" "current" {}

#output "account_id" {
#  description = "AWS account ID"
#  value       = data.aws_caller_identity.current.account_id
#}
