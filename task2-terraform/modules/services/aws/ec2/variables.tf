
##### HERE we define structre and types for the variables coz they have to be dinfed upfront
variable "ec2_map" {
  type = map(object({
    id = number
    ami = string
    ec2_name = string
    instance_type = string
    availability_zone = string
    subnet_id = string
    enclave_options = string
    public = string
    key_name = string
    root_block_device = map(string)
    aws_eip = string
    vpc_tags = map(string)
    vpc = map(string)
    #public = map(string)
    tags = map(string)
    aws_security_group_in = map(object({
      protocol = string
      from_port = number
      to_port = number
      cidr_blocks = list(string)
      type = string
      description = optional(string)
      ipv6_cidr_blocks = optional(list(string))
      prefix_list_ids = optional(list(string))
      self = optional(bool)
    }))
  }))
}

