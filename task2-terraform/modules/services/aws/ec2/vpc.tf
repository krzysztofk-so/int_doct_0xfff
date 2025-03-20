
#### Definition of the VPC, here I'm defining if the VPC excists or if it should be re-used

## I'm using locals as local are very good to define variables and we can apply transformation to set up the input values for the resources.
locals {
  ## checking if VPC is true (that was chosen in the main.tf) 
  ## first adding instance if ["vpc"]["vpc_custom"] == "true"] in order to generate VPC for this instance
  vpc_to_create_true = [for instance_key, instance_value in var.ec2_map : instance_key if instance_value["vpc"]["vpc_custom"] == "true"]
  ### here adding instances if they VPC is false meaning, we will re-use existing one.
  vpc_to_create_false = [for instance_key_f, instance_value_f in var.ec2_map : instance_key_f if instance_value_f["vpc"]["vpc_custom"] == "false"]
  
  ## This line creates a map called vpc_to_create_true_map, which extracts the "aws_security_group_in" configuration from each instance in the ec2_map variable. 
  ## It is used to easily access and manage the security group rules associated with each EC2 instance, facilitating the setup of network security configurations.
  vpc_to_create_true_map = { for k,v in var.ec2_map : k => v["aws_security_group_in"]  }
  #
  # vpc_to_create_true_map -> has to be flatten so we can iterate ofver rule (all maps inside maps will become a single element)
  map_flatten = merge([for k1, v1 in local.vpc_to_create_true_map : { for k2, v2 in v1 : "${k1}.${k2}" => v2 }]...)
  
}



## This resource block is needed to create a new VPC for each EC2 instance that requires a custom VPC, as specified in the ec2_map variable.
resource "aws_vpc" "vpc" {
  for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" }
  cidr_block = each.value.vpc.cidr_block
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}"
  })
}

## So basically if VPC in not true it will create an empty resource otheriwse it will go for data vpc

# Here I'm defining part to check if VPC needs to be re-used so if yes 
data "aws_vpc" "vpc" {
  for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "false" }
  tags = merge(var.ec2_map[each.key]["vpc_tags"])
}


## we would need it for VPC if it'S true a internet gateway
resource "aws_internet_gateway" "ec2" {
    for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" }
    vpc_id =  aws_vpc.vpc[each.key].id
    tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}"
  })
}

##### THE same here for the subnets!! I'm defning here subnet private public with the routing  I'm merging all of the tags from main.tf wanna cover
### Each subnet needs a routeble for public and private.

resource "aws_subnet" "publicsubnet_a_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
   vpc_id =  aws_vpc.vpc[each.key].id
   cidr_block = each.value.vpc.cidr_block_subnet_public_a
   availability_zone = "${each.value.vpc.aws_region}a"
   tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}-public-a"
  })
}

resource "aws_subnet" "publicsubnet_b_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
   vpc_id =  aws_vpc.vpc[each.key].id
   cidr_block = each.value.vpc.cidr_block_subnet_public_b
   availability_zone = "${each.value.vpc.aws_region}b"
   tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}-public-b"
  })
}

resource "aws_subnet" "publicsubnet_c_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
   vpc_id =  aws_vpc.vpc[each.key].id
   cidr_block = each.value.vpc.cidr_block_subnet_public_c
   availability_zone = "${each.value.vpc.aws_region}c"
   tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}-public-c"
  })
}

resource "aws_subnet" "privatesubnet_a_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "false"}
   vpc_id =  aws_vpc.vpc[each.key].id
   cidr_block = each.value.vpc.cidr_block_subnet_private_a
   availability_zone = "${each.value.vpc.aws_region}a"
   tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}-private-a"
  })
}

resource "aws_subnet" "privatesubnet_b_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "false" }
   vpc_id =  aws_vpc.vpc[each.key].id
   cidr_block = each.value.vpc.cidr_block_subnet_private_b
   availability_zone = "${each.value.vpc.aws_region}b"
   tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}-private-b"
  })
}

resource "aws_subnet" "privatesubnet_c_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "false" }
   vpc_id =  aws_vpc.vpc[each.key].id
   cidr_block = each.value.vpc.cidr_block_subnet_private_c
   availability_zone = "${each.value.vpc.aws_region}c"
   tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}-private-c"
  })
}

 resource "aws_route_table" "publicsubnet" {
    for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
    vpc_id =  aws_vpc.vpc[each.key].id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.ec2[each.key].id
    }
    tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}"
    })
 }




 resource "aws_route_table_association" "publicsubnet_a_tf" {
   for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
   subnet_id = aws_subnet.publicsubnet_a_tf[each.key].id
   route_table_id = aws_route_table.publicsubnet[each.key].id
}

resource "aws_route_table_association" "publicsubnet_b_tf" {
  for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
  subnet_id = aws_subnet.publicsubnet_b_tf[each.key].id
  route_table_id = aws_route_table.publicsubnet[each.key].id
}

resource "aws_route_table_association" "publicsubnet_c_tf" {
  for_each = {for k, v in var.ec2_map : k => v if v["vpc"]["vpc_custom"] == "true" && v["public"] == "true" }
  subnet_id = aws_subnet.publicsubnet_c_tf[each.key].id
  route_table_id = aws_route_table.publicsubnet[each.key].id
}

