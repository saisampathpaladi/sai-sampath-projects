# main.tf

# Specify the required provider
provider "aws" {
  region = "us-west-1" # Replace with your desired region
}

# Generate a random string for the bucket name suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
}

# Define local variables
locals {
  bucket_name = "sampath-s3-${random_string.suffix.result}"
}

# Create an S3 bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = local.bucket_name
  acl    = "public-read"

  # Enable static website hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Upload index.html file
resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "path/to/your/index.html" # Replace with the path to your index.html file
  acl    = "public-read"
}

# Upload error.html file
resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = "path/to/your/error.html" # Replace with the path to your error.html file
  acl    = "public-read"
}

# Output the website URL
output "website_url" {
  value       = aws_s3_bucket.website_bucket.website_endpoint
  description = "URL of the S3 static website"
}
