module "ec2" {
  source = "../modules/services/aws/ec2"

  providers = {
    aws = aws.prod
  }
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
         "map-migrated" = "mig39405",
         "owner" = "data-platform",
         "project" = "tinyyo",
         "environment" = "production",
         "ManagedBy" = "terraform"
         "connect" = "yes"
       }
       "vpc_tags" = {
           "Name" = "VPC/Main"
       }
       "aws_eip" = "true"
       "vpc" = {
         "vpc_custom" = "false"
       }
       aws_security_group_in = {
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
          allow_80 = {
            protocol                 = "tcp"
            from_port                = 80
            to_port                  = 80
            cidr_blocks              = ["0.0.0.0/0"]
            type                     = "ingress"
          }
          allow_443 = {
            protocol                 = "tcp"
            from_port                = 443
            to_port                  = 443
            cidr_blocks              = ["0.0.0.0/0"]
            type                     = "ingress"
          }
          allow_ftp = {
            protocol                 = "tcp"
            from_port                = 21
            to_port                  = 21
            cidr_blocks              = ["85.199.126.202/32","213.61.105.234/32","5.69.202.61/32"]
            type                     = "ingress"
          }
          allow_passive = {
            protocol                 = "tcp"
            from_port                = 49152
            to_port                  = 65534
            cidr_blocks              = ["85.199.126.202/32","213.61.105.234/32","5.69.202.61/32"]
            type                     = "ingress"
          }
          allow_cp = {
            protocol                 = "tcp"
            from_port                = 8443
            to_port                  = 8443
            cidr_blocks              = ["0.0.0.0/0"]
            type                     = "ingress"
          }
       }
    },
  }
}

output "vpc_to_create_true_main" {
  description = "The JSON content of the IAM policy documents"
  value = module.ec2.vpc_to_create_true
}


output "vpc_to_create_true_map_main" {
  description = "The JSON content of the IAM policy documents"
  #value = module.ec2.vpc_to_create_true_map
  value = { for k,v in module.ec2.vpc_to_create_true_map : k =>v }
}

output "map_flatten_main" {
  description = "The JSON content of the IAM policy documents"

  value = { for k,v in module.ec2.map_flatten : k =>v }
}
