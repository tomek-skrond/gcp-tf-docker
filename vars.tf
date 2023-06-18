variable "credential_file" {}
variable "project_id" {}
variable "region" {}
variable "project_zone" {}
variable "cloudflare_api_key" {
    type = string
    sensitive = true
}
variable "domain" {
    type = string
    sensitive = true
}
variable "zone_id" {
    type = string
    sensitive = true
}