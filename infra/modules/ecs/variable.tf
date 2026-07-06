variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}

variable "public_subnet_id_2" {
  description = "Second Public Subnet ID"
  type        = string
}

variable "cpu" {
  description = "ECS Task CPU"
  type        = number
}

variable "memory" {
  description = "ECS Task Memory"
  type        = number
}