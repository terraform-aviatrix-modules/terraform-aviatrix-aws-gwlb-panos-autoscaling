variable "aviatrix_vpc" {
  description = "VPC Object with all attributes"
}

variable "secondary_cidr" {
  description = "Secondary CIDR Block to add to Transit Firenet VPC. Used for deployment of all resources in this module."
  type        = string
}

variable "az1" {
  description = "Concatenates with region to form az names. e.g. eu-central-1a."
  type        = string
  default     = "a"
}

variable "az2" {
  description = "Concatenates with region to form az names. e.g. eu-central-1b."
  type        = string
  default     = "b"
}

locals {
  cidrbits = tonumber(split("/", var.secondary_cidr)[1])
  newbits  = 28 - local.cidrbits
  netnum   = pow(2, local.newbits)

  lambda1_subnet = cidrsubnet(var.secondary_cidr, local.newbits, local.netnum - 1)
  lambda2_subnet = cidrsubnet(var.secondary_cidr, local.newbits, local.netnum - 2)

}