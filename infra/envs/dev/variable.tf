variable "aws_region" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "backup_retention" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "ecs_cpu" {
  type = number
}

variable "ecs_memory" {
  type = number
}