resource "google_compute_firewall" "nest_firewall_rule" {
  project     = "testing-429803"
  name        = "laravel-firewall-rule"
  network     = "default"
  description = "Firewall rule allowing TCP traffic on port 8000"

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  priority  = 1000
  direction = "INGRESS"

  source_ranges = [
    "0.0.0.0/0"
  ]
}
