variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3
    error_message = "bucket_name must contain at least 3 characters."
  }
}
