# Variables for Cloudflare Terraform configuration

variable "cloudflare_zone_name" {
  description = "The Cloudflare zone name (domain)"
  type        = string
  default     = "kapabeauty.com"
}

variable "github_pages_domain" {
  description = "Your GitHub Pages domain"
  type        = string
  default     = "alisade.github.io"
}

variable "enable_cloudflare_proxy" {
  description = "Enable Cloudflare proxy (orange cloud) for DNS records"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6 AAAA records for GitHub Pages"
  type        = bool
  default     = true
}

# GitHub Pages IP addresses (these change rarely but can be updated if needed)
variable "github_pages_ips" {
  description = "GitHub Pages IPv4 addresses"
  type        = list(string)
  default = [
    "185.199.108.153",
    "185.199.109.153", 
    "185.199.110.153",
    "185.199.111.153"
  ]
}

variable "github_pages_ipv6" {
  description = "GitHub Pages IPv6 addresses"
  type        = list(string)
  default = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153", 
    "2606:50c0:8003::153"
  ]
}
