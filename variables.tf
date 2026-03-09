variable "location" {
  type    = string
  default = "uksouth"
}

variable "subscriptions" {
  description = "Subscription IDs by purpose"
  type = object({
    identity     = string
    connectivity = string
    management   = string
  })
}


