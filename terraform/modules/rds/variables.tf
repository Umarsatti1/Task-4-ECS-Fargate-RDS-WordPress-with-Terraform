variable "private_subnets" {
  type        = any
}

variable "security_group_private_id" {
  type        = string
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "db_name" {
  type        = string
}