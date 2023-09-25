output "bucket_name"{
  description = "Bucket name for our static website hosting"
  value = module.terrahouse_aws.bucket_name
}

output "S3_website_endpoint" {
  description = "Se Static Website hosting endpoint"
  value = module.terrahouse_aws.website_endpoint
}