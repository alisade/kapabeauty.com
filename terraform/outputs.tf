# Output values from Cloudflare Terraform configuration

output "zone_id" {
  description = "The Cloudflare zone ID"
  value       = data.cloudflare_zone.kapabeauty.id
}

output "zone_name" {
  description = "The domain name"
  value       = data.cloudflare_zone.kapabeauty.name
}

output "a_records" {
  description = "A records created for GitHub Pages"
  value = [
    for record in cloudflare_record.github_pages_a : {
      name  = record.name
      value = record.value
      type  = record.type
    }
  ]
}

output "cname_record" {
  description = "CNAME record for www subdomain"
  value = {
    name  = cloudflare_record.www_cname.name
    value = cloudflare_record.www_cname.value
    type  = cloudflare_record.www_cname.type
  }
}

output "aaaa_records" {
  description = "AAAA records for IPv6 (if enabled)"
  value = var.enable_ipv6 ? [
    for record in cloudflare_record.github_pages_aaaa : {
      name  = record.name
      value = record.value
      type  = record.type
    }
  ] : []
}

output "website_urls" {
  description = "URLs where your website will be accessible"
  value = [
    "https://${var.cloudflare_zone_name}",
    "https://www.${var.cloudflare_zone_name}"
  ]
}

output "github_pages_setup" {
  description = "Next steps for GitHub Pages configuration"
  value = {
    custom_domain = var.cloudflare_zone_name
    repository_url = "https://github.com/alisade/kapabeauty.com/settings/pages"
    instructions = "Go to repository Settings → Pages and set custom domain to: ${var.cloudflare_zone_name}"
  }
}
