
output "s3_static_website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.example-config.website_endpoint}"
}
