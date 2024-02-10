#########################################
# Global
#########################################
variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
  default = {}  
}

#########################################
# S3 bucket
#########################################
variable "bucket_name" {
  description = "The name of the bucket. If ommitted, Terraform will assign a random, unique name."
  type = string
  nullable = false
}

variable "force_destroy" {
  description = "(Optional, Default: false) A boolean that indicates all object should be deleted from the bucket so that the bucket can be deleted without error. These objects are not recoverable."
  type = bool
  default = false  
}

variable "upload_sample_file" {
  default     = false
  description = "Upload sample html file to s3 bucket"
}

#########################################
# CloudFront
#########################################
variable "origin_domain_name" {
  description = "The domain name of the origin for CloudFront"
  type        = string
}

variable "allowed_methods" {
  description = "HTTP methods CloudFront forwards to your origin"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
}

