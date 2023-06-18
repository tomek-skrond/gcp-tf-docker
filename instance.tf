# Create a single Compute Engine instance
locals {
  ssh_keys = {
    "local_key" = { user = "venus", pubkey = "~/.ssh/id_rsa_venus.pub" },
    "ansible"   = { user = "ansible", pubkey = "~/.ssh/ansible.pub" }
  }
  privkey_ansible = "~/.ssh/ansible"
  playbook        = "setup.yaml"
}

resource "google_compute_address" "default" {
  name   = "vm-static-addr"
  region = var.region
}

resource "google_compute_instance" "default" {
  #  This configuration somehow does not work & i have to add keys manually - can't fix for now
  metadata = {
    "ssh-keys" = <<EOT
      ${local.ssh_keys.ansible.user}:${file(local.ssh_keys.ansible.pubkey)}
      ${local.ssh_keys.local_key.user}:${file(local.ssh_keys.local_key.pubkey)}
    EOT
  }

  name         = "sample-vm"
  machine_type = "e2-micro"
  zone         = var.project_zone
  tags         = ["ssh", "allow-http","http-server","https-server"]

  boot_disk {
    initialize_params {
      #image = "centos-cloud/centos-stream-9"
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {

    }
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until ssh is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_keys.ansible.user
      private_key = file(local.privkey_ansible)
      host        = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
    }
  }
  provisioner "local-exec" {
    command = <<-EOT
    ssh-keyscan -H ${google_compute_instance.default.network_interface.0.access_config.0.nat_ip} >> ~/.ssh/known_hosts
    ansible-playbook -i ${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}, --private-key ${local.privkey_ansible} ansible/${local.playbook}
    EOT
  }
}
