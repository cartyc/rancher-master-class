
# GCP Public Compute Address for rancher server node
# resource "google_compute_address" "rancher_server_address" {
#   name = "rancher-server-ipv4-address"
# }

resource "google_compute_network" "k8s_network" {
  name = "k8s-network"
}

resource "google_compute_firewall" "k8s" {
  name    = "k8s-firewall"
  network = google_compute_network.k8s_network.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  source_tags = ["k8s"]
}


resource "google_compute_firewall" "external" {
  name    = "k8s-external"
  network = google_compute_network.k8s_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  name         = "rancher-master"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"

  tags = ["foo", "bar", "k8s"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 30
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = google_compute_network.k8s_network.name

    access_config {
      nat_ip = "35.238.196.199"
    }
  }

  metadata = {
    foo            = "bar"

    ssh-keys = "terraform:${file("/home/carty/.ssh/gcloud.pub")}"
    user-data = templatefile("install.template", {
      docker_version = "18.09"
      username       = "terraform"
    })
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type        = "ssh"
      host        = "35.238.196.199"
      user        = "terraform"
      private_key = file("/home/carty/.ssh/gcloud")
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

module "rke" {
  source = "../rke"

  node_public_ip   = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  node_internal_ip = google_compute_instance.default.network_interface.0.network_ip
}