variable "bucket_name" {
  description = "S3 Frontend"

  type = string
}

variable "cloudfront_arn" {
  type        = string
  description = "The ARN of the CloudFront distribution allowed to access the bucket"
}
