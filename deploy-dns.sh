#!/bin/bash

# Cloudflare DNS Setup Script for kapabeauty.com
# This script helps you deploy DNS records for GitHub Pages using Terraform

set -e

echo "installing required tools"
brew install terraform ansible

echo "🚀 Kapa Beauty - Cloudflare DNS Setup for GitHub Pages"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f "hugo.toml" ]; then
    echo "❌ Error: Please run this script from the kapabeauty.com project root"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Error: Terraform is not installed"
    echo "📥 Install from: https://www.terraform.io/downloads"
    exit 1
fi

# Check for Cloudflare API token
export CLOUDFLARE_API_TOKEN=$(ansible-vault decrypt cloudflare.ansible.vault --output -)
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ Error: CLOUDFLARE_API_TOKEN environment variable not set"
    echo ""
    echo "🔑 Please set your Cloudflare API token:"
    echo "   export CLOUDFLARE_API_TOKEN='your_token_here'"
    echo ""
    echo "📖 Get your token at: https://dash.cloudflare.com/profile/api-tokens"
    echo "   Permissions needed: Zone:Zone:Read, Zone:DNS:Edit"
    exit 1
fi

cd terraform

# Create terraform.tfvars if it doesn't exist
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creating terraform.tfvars from example..."
    cp terraform.tfvars.example terraform.tfvars
    echo "✅ Created terraform.tfvars - you can customize it if needed"
fi

echo ""
echo "🔧 Initializing Terraform..."
terraform init

echo ""
echo "📋 Planning DNS changes..."
terraform plan

echo ""
read -p "🚀 Apply these DNS changes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 Applying DNS configuration..."
    terraform apply -auto-approve
    
    echo ""
    echo "✅ DNS records created successfully!"
    echo ""
    echo "🔗 Next steps:"
    echo "1. Wait for DNS propagation (up to 24 hours)"
    echo "2. Go to: https://github.com/alisade/kapabeauty.com/settings/pages"
    echo "3. Set custom domain to: kapabeauty.com"
    echo "4. Enable 'Enforce HTTPS'"
    echo ""
    echo "🌐 Your site will be available at:"
    echo "   - https://kapabeauty.com"
    echo "   - https://www.kapabeauty.com"
    echo ""
    echo "🔍 Check DNS propagation at: https://www.whatsmydns.net/#A/kapabeauty.com"
else
    echo "❌ DNS changes cancelled"
fi
