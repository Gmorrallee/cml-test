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

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
    enabled          = bool
  }))
}


