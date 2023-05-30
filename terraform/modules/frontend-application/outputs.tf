output "s3_static_website_url" {
  value = aws_s3_bucket.frontend-app-bucket.bucket_domain_name
}

output "s3_static_website_urlv2" {
  value = aws_s3_bucket.frontend-app-bucket.website_endpoint
}
