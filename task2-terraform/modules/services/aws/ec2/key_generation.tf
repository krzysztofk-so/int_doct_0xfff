resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "aws_key_pair" "existing_key" {
  for_each = var.ec2_map
  key_name = each.value.key_name
}

resource "aws_key_pair" "generated_key" {
  for_each = { for k, v in var.ec2_map : k => v if length(data.aws_key_pair.existing_key[k].id) == 0 }
  key_name   = each.value.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "null_resource" "generate_key_file" {
  for_each = { for k, v in var.ec2_map : k => v if length(data.aws_key_pair.existing_key[k].id) == 0 }

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ec2_key.private_key_pem}' > ./'${each.value.key_name}'.pem
      chmod 400 ./'${each.value.key_name}'.pem
    EOT
  }
}

output "existing_keys" {
  value = { for k, v in data.aws_key_pair.existing_key : k => v.id }
}
