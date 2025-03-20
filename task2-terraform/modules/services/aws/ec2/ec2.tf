locals {
  az_to_subnet_resource_mapping_public = {
    "eu-central-1a" = aws_subnet.publicsubnet_a_tf
    "eu-central-1b" = aws_subnet.publicsubnet_b_tf
    "eu-central-1c" = aws_subnet.publicsubnet_c_tf
  }

  az_to_subnet_resource_mapping_private = {
    "eu-central-1a" = aws_subnet.privatesubnet_a_tf
    "eu-central-1b" = aws_subnet.privatesubnet_b_tf
    "eu-central-1c" = aws_subnet.privatesubnet_c_tf
  }
}

### Here is the main definition for the EC2 resources which are needed to create a new instance, we are lopping through the  values send via main.tf in the root directory.

resource "aws_instance" "ec2" {
  
  for_each = var.ec2_map

  ami = each.value.ami
  instance_type   = each.value.instance_type
  #coalesce will return the key name from the existing key pair if it exists; otherwise, it will return the key name from the newly generated key pair.
  key_name   = coalesce(try(data.aws_key_pair.existing_key[each.key].key_name, null), try(aws_key_pair.generated_key[each.key].key_name, null))
  vpc_security_group_ids = [ aws_security_group.allow[each.key].id ]
  availability_zone = each.value.availability_zone
  hibernation = "false"

  ## Here I'm using conditional if there is VPC custom -> true and public we take data 
  ## from az_to_subnet_resource_mapping_public otherwise from az_to_subnet_resource_mapping_private or from subnet_id if it was set and needs to be re-used.
  subnet_id = length(local.vpc_to_create_true) > 0 && each.value.public == "true" ? local.az_to_subnet_resource_mapping_public[each.value.availability_zone][each.key].id : length(local.vpc_to_create_true) > 0 && each.value.public == "false" ? local.az_to_subnet_resource_mapping_private[each.value.availability_zone][each.key].id : length(local.vpc_to_create_false) > 0 ? each.value.subnet_id : null
  tags = merge(var.ec2_map[each.key]["tags"],{
    "Name" = "${var.ec2_map[each.key]["ec2_name"]}"
  })

  credit_specification {
    cpu_credits = "standard"
  }

  enclave_options {
     enabled = each.value.enclave_options
  }
  
  # root disk
  root_block_device {
    iops                  = try(each.value.root_block_device.iops, null)
    throughput            = each.value.root_block_device.throughput
    volume_size           = each.value.root_block_device.volume_size
    volume_type           = each.value.root_block_device.volume_type
    encrypted             = each.value.root_block_device.encrypted
    delete_on_termination = each.value.root_block_device.delete_on_termination

    tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["ec2_name"]}"
    })
  } 

}

## Here I'm adding EIP to the instacne generating one
resource "aws_eip" "ec2" {
  for_each = {for k, instance in var.ec2_map : k => instance if instance["aws_eip"] == "true"}
  vpc = true
  instance = aws_instance.ec2[each.key].id
  tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["ec2_name"]}"
  })
}


resource "null_resource" "ansible_installation" {
  for_each = var.ec2_map

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./${each.value.key_name}.pem")
      host        = aws_instance.ec2[each.key].public_ip
    }

    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y"
    ]
  }
}

resource "null_resource" "ansible_playbook_execution" {
  for_each = var.ec2_map

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./${each.value.key_name}.pem")
      host        = aws_instance.ec2[each.key].public_ip
    }

    inline = [
      "ansible-playbook /srv/scripts/ansible/playbook.yml"
    ]
  }

  depends_on = [null_resource.ansible_installation]
}

