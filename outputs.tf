output "bucket_name"{
  description = "Bucket name for our static website hosting"
  value = module.home_01_hosting.bucket_name
}

output "S3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_01_hosting.website_endpoint
}

output "domain_name" {
  description = "The CloudFront Distribution Domain Name"
  value = module.home_01_hosting.domain_name
}