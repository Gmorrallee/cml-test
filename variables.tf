variable "location" {
  type    = string
  default = "uksouth"
}

variable "subscriptions" {
  type = object({
    identity     = string
    connectivity = string
  })
}
