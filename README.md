# Palo Alto auto scaling using AWS GWLB in combination with Aviatrix transit architecture

### Description
This module was developed to be used in conjuntion with terraform-aviatrix-aws-transit-firenet, to extend the Aviatrix firenet function with an auto scaling Palo Alto firewall environment using a AWS GWLB.
This module is modeled after this CloudFormation template provided by Palo Alto Networks: https://github.com/PaloAltoNetworks/AWS-GWLB-VMSeries/tree/main/cft%20with%20autoscale, and adapted for use with Aviatrix' transit architecture.

### Diagram
\<Provide a diagram of the high level constructs thet will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | >= 0.13 | >= 6.4 | >= 2.19.0

### Usage Example
```
module "panw_autoscaling_cluster" {
  source  = "terraform-aviatrix-modules/aws-gwlb-panos-autoscaling/aviatrix"
  version = "1.0.0"

  secondary_cidr = "10.1.1.0/24"
  transit_gw = "eu-west-1-transit"
  region = "eu-west-1"
  vpc_id = "vpc-982347978873490123"
}
```

### Variables
The following variables are required:

key | value
:--- | :---
\<keyname> | \<description of value that should be provided in this variable>

The following variables are optional:

key | default | value 
:---|:---|:---
\<keyname> | \<default value> | \<description of value that should be provided in this variable>

### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
