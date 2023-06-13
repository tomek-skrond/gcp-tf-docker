provider "google" {
  credentials = file(var.credential_file)
  project     = var.project_id
  region      = var.region
  zone        = var.project_zone
}