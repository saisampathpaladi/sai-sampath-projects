# main.tf

# Specify the required provider
provider "aws" {
  region = "us-west-1" # Replace with your desired region
}

# Generate a random string for the bucket name suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Define local variables
locals {
  bucket_name = "sampath-s3-${random_string.suffix.result}"
}

# Create an S3 bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = local.bucket_name

  # Enable static website hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Configure public access block settings
resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Upload index.html file
resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "path:\\Users\\terraform-projects\\terraform_static_web hosting S3 buckets\\index.html" # Replace with the path to your index.html file
  content_type = "text/html"
}

# Upload error.html file
resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = "path:\\Users\\terraform-projects\\terraform_static_web hosting S3 buckets\\error.html" # Replace with the path to your error.html file
  content_type = "text/html"
}

# Output the website URL
output "website_url" {
  value       = aws_s3_bucket.website_bucket.website_endpoint
  description = "URL of the S3 static website"
}
