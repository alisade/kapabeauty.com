# Terraform configuration for Cloudflare DNS records
# This configures kapabeauty.com to point to GitHub Pages

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Configure the Cloudflare Provider
provider "cloudflare" {
  # API token should be set via environment variable CLOUDFLARE_API_TOKEN
  # You can also use email + api_key if you prefer (not recommended)
}

# Get your zone information
data "cloudflare_zone" "kapabeauty" {
  name = var.cloudflare_zone_name
}

# A records for apex domain pointing to GitHub Pages
resource "cloudflare_record" "github_pages_a" {
  count   = length(var.github_pages_ips)
  zone_id = data.cloudflare_zone.kapabeauty.id
  name    = "@"
  value   = var.github_pages_ips[count.index]
  type    = "A"
  ttl     = 1 # 1 = automatic (recommended for GitHub Pages)
  proxied = var.enable_cloudflare_proxy
}

# CNAME record for www subdomain pointing to your GitHub Pages domain
resource "cloudflare_record" "www_cname" {
  zone_id = data.cloudflare_zone.kapabeauty.id
  name    = "www"
  value   = var.github_pages_domain
  type    = "CNAME"
  ttl     = 1
  proxied = var.enable_cloudflare_proxy
}

# AAAA records for IPv6 support (optional)
resource "cloudflare_record" "github_pages_aaaa" {
  count   = var.enable_ipv6 ? length(var.github_pages_ipv6) : 0
  zone_id = data.cloudflare_zone.kapabeauty.id
  name    = "@"
  value   = var.github_pages_ipv6[count.index]
  type    = "AAAA"
  ttl     = 1
  proxied = var.enable_cloudflare_proxy
}

# Optional: Page Rule for www redirect (uncomment if needed)
# resource "cloudflare_page_rule" "www_redirect" {
#   zone_id = data.cloudflare_zone.kapabeauty.id
#   target  = "www.${var.cloudflare_zone_name}/*"
#   priority = 1
#   
#   actions {
#     forwarding_url {
#       url         = "https://${var.cloudflare_zone_name}/$1"
#       status_code = 301
#     }
#   }
# }
