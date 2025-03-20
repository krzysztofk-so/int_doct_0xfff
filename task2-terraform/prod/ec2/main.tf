#So, I have used main.tf to invoke modules and pass parameters to the module. The parameters were specified as a map, which are 
#needed to create an EC2 instance, such as the name, network disk volume, and SSH key. Additionally, I'm retrieving the outputs from the module.



## initializing module

module "ec2" {
  source = "../modules/services/aws/ec2" ## path definitation so we can refer to the differnt locations


### here I'm using provider alias, it would be needed e.g: if we have different AWS accunt which are under one organization

  providers = {
    aws = aws.prod
  }

## defnition of the maps which value we will define and use for ec2 instance that we want to generate.

  ec2_map = {
    "ubuntu" : {
       "id" = "1"
       "ec2_name" = "ubuntu"
       "ami" = "ami-075d8cd2ff03fa6e9"
       "instance_type" = "t2.micro"
       "availability_zone" = "eu-central-1a"
       "subnet_id" = "subnet-0241cb73afb2a32c1" #use this if you want to-re-use subnet
       "enclave_options" = "false"
       "public" = "true"
       "key_name" = "prod_key"
       "root_block_device" = {
          "throughput" = "125"
          "volume_size" = "250"
          "volume_type" = "gp3"
          "encrypted" = "false"
          "delete_on_termination" = "false"
       }
       "tags" = {
         "env" = "prod",
       }
       "vpc_tags" = {
           "Name" = "VPC/Main"
       }
       "aws_eip" = "true"
       "vpc" = {
         "vpc_custom" = "false"
       }
       aws_security_group_in = { ## security groups that is needed and must be attached
         allow_in = {
            protocol                 = "tcp"
            from_port                = 22
            to_port                  = 22
            cidr_blocks              = ["0.0.0.0/0"]
            type                     = "ingress"
          }
          egress_all = {
            description      = " all egress"
            protocol         = "-1"
            from_port        = 0
            to_port          = 0
            type             = "egress"
            cidr_blocks      = ["0.0.0.0/0"]
          }
       }
    },
  }
}

