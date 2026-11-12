variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "rdicidr"
}

variable "environment" {
  type        = string
  description = "Deployment environment; scopes resource names and state"

  validation {
    condition     = contains(["devel", "stage"], var.environment)
    error_message = "environment must be one of: devel, stage."
  }
}

variable "container_image" {
  type        = string
  description = "Image URI override; defaults to <this env's ECR repo>:latest"
  default     = null
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}

variable "health_check_path" {
  type        = string
  description = "Health check endpoint path"
  default     = "/health"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks to run"
  default     = 2
}
