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
  aviatrix_vpc = module.transit_firenet.vpc
  Az1NatGW = 
  Az2NatGW = 
  
}
```

### Variables
The following variables are required:

key | value
:--- | :---
secondary_cidr |
aviatrix_vpc |
ssh_key_name | 
Az1NatGW |
Az2NatGW |

The following variables are optional:

key | default | value 
:---|:---|:---
panos_image_name | PA-VM-AWS-* | Name of the panos image for AMI lookup and aws_launch_template creation.
az1 | "a" |
az2 | "b" |
fw_instance_size | c5.xlarge | Size of the firewall instances

### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
