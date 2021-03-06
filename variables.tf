variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_region" {}

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

variable "replica_count" {
  description = "The desired number of service replicas at any given time."
  default = 2
}

variable "load_balancer_name" {
  description = "The name to give our load balancer."
  default = "resume-app-lb"
}

variable "ecs_container_name" {
  description = "The name to give our containers."
  default = "resume_app"
}

variable "container_port" {
  description = "The port to expect our service to be running on."
  default = "4567"
}

variable "task_cpu_units" {
  description = "The number of CPU units to allocate to this task."
  default = "512"
}

variable "task_memory_units" {
  description = "The number of memory units to allocate to this task."
  default = "1024"
}

variable "logs_name" {
  description = <<DESCRIPTION
The name for the CloudWatch logging group used by the ECS task for resume-app.
DESCRIPTION
  default = "resume_app_logs"
}

variable "ecs_cluster_name" {
  description = "The name of our ECS cluster."
  default = "resume_app_ecs_cluster"
}

variable "dns_zone_name" {
  description = "The name of the DNS zone within which resume-app will reside."
}

variable "dns_record_name" {
  description = "The name of the A record to create for this app. It will reside in the zone provided by `dns_zone`."
}

variable "lb_vpc_cidr_block" {
  description = "The CIDR block to use for our load balancers."
}

variable "environment" {
  description = "The environment in which these resources will live."
}

variable "docker_hub_username" {
  description = "The username to use for the Docker repository hosting this image."
}
