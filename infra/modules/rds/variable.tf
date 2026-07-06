variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
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

variable "instance_class" {
  type = string
}

variable "backup_retention" {
  type = number
}

variable "deletion_protection" {
  type = bool
}