resource "aws_s3_bucket" "frontend-app-bucket" {
  bucket = var.bucketName
}

resource "aws_s3_bucket_public_access_block" "frontend-app-bucket" {
  bucket                  = aws_s3_bucket.frontend-app-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "example-policy" {
  bucket     = aws_s3_bucket.frontend-app-bucket.id
  policy     = templatefile("${path.module}/files/s3-policy.json", { bucket = var.bucketName })
  depends_on = [aws_s3_bucket_public_access_block.frontend-app-bucket]
}

resource "aws_s3_bucket_website_configuration" "example-config" {
  bucket = aws_s3_bucket.frontend-app-bucket.bucket
  index_document {
    suffix = "index.html"
  }
}

# resource "aws_s3_object" "example-index" {
#   bucket       = aws_s3_bucket.frontend-app-bucket.id
#   key          = "index.html"
#   source       = "../index.html"
#   content_type = "text/html"
# }
locals {
  todo_webapp_files = fileset("../dist/todo-webapp", "**/*")
}

locals {
  content_type_map = {
    "html" = "text/html"
    "js"   = "text/javascript"
    "css"  = "text/css"
    "txt"  = "text/plain"
    "ico"  = "image/x-icon"
    "svg" : "image/svg+xml"
  }
}

resource "aws_s3_object" "todo-webapp-assets" {
  for_each = local.todo_webapp_files

  bucket = aws_s3_bucket.frontend-app-bucket.id
  key    = each.value

  source = "../${var.frontendAppDistPath}/${each.value}"
  etag   = filemd5("../${var.frontendAppDistPath}/${each.value}")
  // simplification of the content type serving
  content_type = lookup(
    local.content_type_map,
    split(".", basename(each.value))[length(split(".", basename(each.value))) - 1],
    "text/html; charset=UTF-8",
  )

  depends_on = [aws_s3_bucket.frontend-app-bucket]
}
