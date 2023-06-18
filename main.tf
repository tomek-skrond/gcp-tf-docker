terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file(var.credential_file)
  project     = var.project_id
  region      = var.region
  zone        = var.project_zone
}

provider "cloudflare" {
  api_token = "${var.cloudflare_api_key}"
}