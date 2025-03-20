
## An example for GCP

resource "google_compute_instance" "vm_instance" {
  for_each = var.instance_map

  name         = each.key
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.image
    }
  }

  network_interface {
    network = each.value.network
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y ansible
    # Optional: Run an Ansible playbook
    # ansible-playbook /path/to/your/playbook.yml
  EOT

  tags = each.value.tags
}