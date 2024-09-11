module "generic_s3" {
  source              = "../modules/storage/s3/generic_s3"
  project_bucket_name = var.general_project_bucket_name
}
