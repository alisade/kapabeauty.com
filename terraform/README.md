# Cloudflare Terraform Configuration for kapabeauty.com

This directory contains Terraform configuration to set up DNS records in Cloudflare for your GitHub Pages website.

## Prerequisites

1. **Cloudflare Account**: Your domain `kapabeauty.com` should be managed by Cloudflare
2. **Terraform Installed**: [Download Terraform](https://www.terraform.io/downloads)
3. **Cloudflare API Token**: Create an API token with DNS edit permissions

## Setup Instructions

### 1. Create Cloudflare API Token

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/profile/api-tokens)
2. Click "Create Token"
3. Use "Custom token" template
4. Set permissions:
   - **Zone:Zone:Read** 
   - **Zone:DNS:Edit**
5. Zone Resources: Include → Specific zone → `kapabeauty.com`
6. Copy the token (you'll need it next)

### 2. Set Environment Variable

```bash
export CLOUDFLARE_API_TOKEN="your_api_token_here"
```

Or create a `.env` file:
```bash
echo "CLOUDFLARE_API_TOKEN=your_api_token_here" > .env
source .env
```

### 3. Initialize and Apply Terraform

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

## Configuration Options

### Basic Configuration (recommended)
The default configuration sets up:
- 4 A records pointing to GitHub Pages IPs
- 1 CNAME record for www subdomain
- 4 AAAA records for IPv6 support

### Advanced Options

#### Enable Cloudflare Proxy (Orange Cloud)
```bash
terraform apply -var="enable_cloudflare_proxy=true"
```

**Pros**: 
- DDoS protection
- CDN acceleration
- SSL/TLS optimization

**Cons**: 
- May interfere with GitHub Pages SSL certificate
- Additional complexity

#### Disable IPv6
```bash
terraform apply -var="enable_ipv6=false"
```

## DNS Records Created

| Type  | Name | Value              | Purpose |
|-------|------|--------------------|---------|
| A     | @    | 185.199.108.153    | GitHub Pages IPv4 |
| A     | @    | 185.199.109.153    | GitHub Pages IPv4 |
| A     | @    | 185.199.110.153    | GitHub Pages IPv4 |
| A     | @    | 185.199.111.153    | GitHub Pages IPv4 |
| CNAME | www  | alisade.github.io  | WWW subdomain |
| AAAA  | @    | 2606:50c0:8000::153| GitHub Pages IPv6 |
| AAAA  | @    | 2606:50c0:8001::153| GitHub Pages IPv6 |
| AAAA  | @    | 2606:50c0:8002::153| GitHub Pages IPv6 |
| AAAA  | @    | 2606:50c0:8003::153| GitHub Pages IPv6 |

## After Applying

1. **Wait for Propagation**: DNS changes can take up to 24 hours to propagate globally
2. **Configure GitHub Pages**: 
   - Go to your repository Settings → Pages
   - Set custom domain to: `kapabeauty.com`
   - Enable "Enforce HTTPS"
3. **Verify**: Check your site at `https://kapabeauty.com`

## Troubleshooting

### Check DNS Propagation
```bash
dig kapabeauty.com
dig www.kapabeauty.com
```

### Verify Terraform State
```bash
terraform show
terraform output
```

### Update GitHub Pages IPs (if needed)
GitHub Pages IP addresses rarely change, but if they do:
```bash
terraform apply -var='github_pages_ips=["new.ip.1","new.ip.2","new.ip.3","new.ip.4"]'
```

## Cleanup

To remove all DNS records:
```bash
terraform destroy
```

## Files

- `cloudflare.tf` - Main Terraform configuration
- `variables.tf` - Input variables and defaults  
- `outputs.tf` - Output values after apply
- `README.md` - This documentation
