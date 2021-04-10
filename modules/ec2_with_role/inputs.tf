variable "github_username" {
  description = "Github username used to import public ssh keys"
  type        = string
}

variable "ssh_cidr_list" {
  description = "List of CIDRs that give ssh access"
  type        = list
  default     = ["198.51.100.50/32"] # put your IP address here
}
