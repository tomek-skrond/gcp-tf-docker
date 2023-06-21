resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "http" {
  name    = "allow-http-rule"
  #network = "my-custom-mode-network"

  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  network = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
  priority    = 1000
}