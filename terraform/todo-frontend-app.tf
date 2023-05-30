module "todo-frontend" {
  source              = "./modules/frontend-application"
  bucketName          = "zeke-todo-webapp"
  frontendAppDistPath = "dist/todo-webapp"
}

output "website_domain" {
  value = module.todo-frontend.s3_static_website_endpoint
}
