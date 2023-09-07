variable "local_ssh_path" {
  description = "Path to the local .ssh directory"
  type        = string
}

variable "namespace" {
  description = "Namespace of project"
  type        = string
  default     = "ghtt"
}

variable "stage" {
  description = "Stage of project"
  type        = string
  default     = "dev"
}

variable "ipv4_cidr_block" {
  description = "Primary ipv4 block occupied by the vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "name_one" {
  description = "Name of the first user to be added to the 'Testers' user group"
  type        = string
}

variable "name_two" {
  description = "Name of the second user to be added to the 'Testers' user group"
  type        = string
}

variable "primary_email_target" {
  description = "Primary email recipient of s3 bucket alerts"
  type        = string
}

variable "secondary_email_target" {
  description = "Secondary email recipient of s3 bucket alerts"
  type        = string
}

variable "whitelisted_ips" {
  description = "list of whitelisted IPs in form of list of strings"
  type        = list(any)
}