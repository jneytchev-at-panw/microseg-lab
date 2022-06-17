resource "google_compute_network" "vpc1" {
  name = "${var.prefix}-vpc1"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "sn1" {
  name          = "${var.prefix}-sn1"
  ip_cidr_range = "10.101.0.0/16"
  network       = google_compute_network.vpc1.id
}

resource "google_compute_subnetwork" "sn2" {
  name          = "${var.prefix}-sn2"
  ip_cidr_range = "10.102.0.0/16"
  network       = google_compute_network.vpc1.id
  private_ip_google_access = "true"
}

resource "google_compute_firewall" "fw1" {
  name    = "${var.prefix}-fw1"
  network = google_compute_network.vpc1.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  description = "allow ssh from IAP"
  priority = 1001
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "fw2" {
  name    = "${var.prefix}-fw2"
  network = google_compute_network.vpc1.name
  allow {
    protocol = "all"
  }
  description = "allow all internal traffic"
  priority = 1002
  source_tags = ["${var.prefix}-ntag"]
  target_tags = ["${var.prefix}-ntag"]
}

resource "google_compute_router" "rtr1" {
  name    = "${var.prefix}-rtr1"
  region  = google_compute_subnetwork.sn1.region
  network = google_compute_network.vpc1.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat1" {
  name                               = "${var.prefix}-nat1"
  router                             = google_compute_router.rtr1.name
  region                             = google_compute_router.rtr1.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

