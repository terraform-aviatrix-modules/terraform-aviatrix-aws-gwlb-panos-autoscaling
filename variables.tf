variable "aviatrix_vpc" {
  description = "VPC Object with all attributes"
}

variable "secondary_cidr" {
  description = "Secondary CIDR Block to add to Transit Firenet VPC. Used for deployment of all resources in this module."
  type        = string
}

variable "ssh_key_name" {
  description = "Name of SSH keypair to use for firewall"
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

variable "panos_image_name" {
  description = "Panos OS AMI image name"
  type        = string
  default     = "PA-VM-AWS-*"
}

variable "fw_instance_size" {
  description = "AWS Instance size for the NGFW's"
  type        = string
  default     = "m4.xlarge"
}

variable "Az1NatGW" {
  description = "NAT GW ID for AZ1"
  type        = string
}

variable "Az2NatGW" {
  description = "NAT GW ID for AZ2"
  type        = string
}

variable "ASGScaleMap" {
  type = map(string)
  default = {
    "MaxInstances" : { "ASG" : "5" },
    "ScaleUpThreshold" : { "ASG" : "80" },
    "ScaleDownThreshold" : { "ASG" : "20" },
    "ScalingParam" : { "CPU" : "DataPlaneCPUUtilizationPct", "AS" : "panSessionActive", "SU" : "panSessionUtilization", "SSPU" : "panSessionSslProxyUtilization", "GPU" : "panGPGatewayUtilizationPct", "GPAT" : "panGPGWUtilizationActiveTunnels", "DPB" : "DataPlanePacketBufferUtilization" },
    "ScalingPeriod" : { "ASG" : "900" }
  }
}

locals {
  cidrbits = tonumber(split("/", var.secondary_cidr)[1])
  newbits  = 28 - local.cidrbits
  netnum   = pow(2, local.newbits)

  lambda1_subnet = cidrsubnet(var.secondary_cidr, local.newbits, local.netnum - 1)
  lambda2_subnet = cidrsubnet(var.secondary_cidr, local.newbits, local.netnum - 2)
  trust1_subnet  = cidrsubnet(var.secondary_cidr, local.newbits, local.netnum - 3)
  trust2_subnet  = cidrsubnet(var.secondary_cidr, local.newbits, local.netnum - 4)
}
