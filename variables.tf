variable "task_family" {
  description = "The name for this ECS task."
  default = "resume_app_service"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket into which resumes will be stored."
}

variable "resume_name" {
  description = "The name of the resume to load."
  default = "latest"
}

variable "app_version" {
  description = "The version of our application to deploy."
}