resource "cloudflare_record" "www" {
    zone_id = var.zone_id
    name = "@"
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
    type = "A"
    proxied = true
}