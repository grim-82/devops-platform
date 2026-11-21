variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3
    error_message = "bucket_name must contain at least 3 characters."
  }
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = false
}

variable "enable_encryption" {
  description = "Enable server-side encryption"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block all public access to the bucket"
  type        = bool
  default     = false
}
