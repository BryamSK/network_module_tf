variable "project_name" {
  description = "The name to use for tags"
  type        = string
}

variable "networks" {
  description = "List networks for created in subnet"
}

variable "base_cidr_block" {
  description = "IP cidr block"
  type        = string
}



