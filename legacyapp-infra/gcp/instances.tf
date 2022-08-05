resource "google_compute_instance" "vm1" {
  name         = "${var.prefix}-vm1"
  machine_type = "e2-medium"
  zone         = var.gcp_zone

  tags = ["${var.prefix}-ntag"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc1.name
    subnetwork = google_compute_subnetwork.sn1.name
  }

  labels = {
    owner = var.owner
    role = "web"
  }

  service_account {
    email  = var.shared_svc_account_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "vm2" {
  name         = "${var.prefix}-vm2"
  machine_type = "e2-medium"
  zone         = var.gcp_zone

  tags = ["${var.prefix}-ntag"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc1.name
    subnetwork = google_compute_subnetwork.sn1.name
  }

  labels = {
    owner = var.owner
    role = "app"
  }

  service_account {
    email  = var.shared_svc_account_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "vm3" {
  name         = "${var.prefix}-vm3"
  machine_type = "e2-medium"
  zone         = var.gcp_zone

  tags = ["${var.prefix}-ntag"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc1.name
    subnetwork = google_compute_subnetwork.sn1.name
  }

  labels = {
    owner = var.owner
    role = "db"
  }

  service_account {
    email  = var.shared_svc_account_email
    scopes = ["cloud-platform"]
  }
}