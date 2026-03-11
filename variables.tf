variable "location" {
  type    = string
  default = "uksouth"
}

variable "location_2" {
  type    = string
  default = "ukwest"
}

variable "subscriptions" {
  description = "Subscription IDs by purpose"
  type = object({
    identity     = string
    connectivity = string
    management   = string
  })
}


variable "firewall_ip_uks" {
  description = "Private IP address of the Azure Firewall in UK South"
  type        = string
}

variable "firewall_ip_ukw" {
  description = "Private IP address of the Azure Firewall in UK West"
  type        = string
}




