variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-2"
}

variable "org" {
  description = "Organization name"
  type        = string
  default     = "beanstalk-org"
}

variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "beanstalk-app"
}

variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of custom ENV variables to be provided to the application running on Elastic Beanstalk, e.g. env_vars = { DB_USER = 'admin' DB_PASS = 'xxxxxx' }"
}
