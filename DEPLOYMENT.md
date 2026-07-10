# Deployment Guide

La Belle Nail Studio is a single-page Hugo site that auto-deploys to GitHub
Pages. This guide covers the deploy pipeline, the custom domain, and DNS.

## How deploys work

Every push to the `main` branch triggers the GitHub Actions workflow at
`.github/workflows/hugo.yml`, which:

1. Installs Hugo Extended (pinned to v0.148.2) and Dart Sass
2. Builds the site with `hugo --gc --minify`
3. Publishes `./public` to GitHub Pages

There is no manual build or theme submodule step. To ship a change:

```bash
# edit content (usually data/studio.yaml), then:
git add -A
git commit -m "Update services"
git push
```

The Action rebuilds and redeploys automatically. You can watch it in the
repository's Actions tab.

## Preview locally before pushing

```bash
hugo server -D
# open http://localhost:1313
```

## GitHub Pages setup (one time)

1. Repository Settings -> Pages
2. Under Source, select GitHub Actions
3. Under Custom domain, enter `labellenailstudio.com`
4. Enable Enforce HTTPS (available once the domain verifies)

The custom domain is committed as `static/CNAME`, which Hugo copies to the site
root as `CNAME` on every build -- so Pages keeps the custom domain across
deploys.

## DNS (Cloudflare via Terraform)

DNS records that point `labellenailstudio.com` at GitHub Pages are managed in
`terraform/` and applied with the helper script:

```bash
./deploy-dns.sh
```

The script:

1. Decrypts the Cloudflare API token from `cloudflare.ansible.vault`
   (via `ansible-vault`) and exports it as `CLOUDFLARE_API_TOKEN`
2. Runs `terraform init` / `plan` in `terraform/`
3. Prompts before `terraform apply`

It creates the GitHub Pages A records (185.199.108-111.153) and AAAA records,
plus the `www` CNAME. The Cloudflare zone name is set in
`terraform/terraform.tfvars` (`labellenailstudio.com`).

After applying, allow time for DNS propagation, then verify at
https://www.whatsmydns.net/#A/labellenailstudio.com.

## Troubleshooting

- **Build fails in Actions:** check the Actions tab log. Most failures are a
  YAML syntax error in `data/studio.yaml` -- validate indentation.
- **Custom domain reverted:** confirm `static/CNAME` still contains
  `labellenailstudio.com` (it is republished on every build).
- **DNS not resolving:** re-run `./deploy-dns.sh` and confirm the records in the
  Cloudflare dashboard; propagation can take up to 24 hours.

## Before going live

The site currently ships with placeholder data. Update these in
`data/studio.yaml`:

- `bookingURL` -- your real Fresha booking link (all "Book" buttons use it)
- Services, prices, `rating` / `reviewCount`, `address`, `phone`, `email`,
  and `instagram`
