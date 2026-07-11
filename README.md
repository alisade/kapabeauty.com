# La Belle Nail Studio

A single-page Hugo website for La Belle Nail Studio -- a link-in-bio landing
page (Linktree style) combined with a Fresha-style service menu. No theme; the
whole page is a self-contained custom layout, and all copy lives in one data
file so content can be edited without touching HTML.

Deployed to GitHub Pages at [labellenailstudio.com](https://labellenailstudio.com).

## Editing content

Everything you see on the page -- studio name, bio, rating, address, the
link-in-bio buttons, the service menu (names, descriptions, durations, prices),
opening hours, and social links -- is defined in a single file:

```
data/studio.yaml
```

Edit that file and rebuild. No HTML knowledge required. Key fields:

- `bookingURL` -- where the "Book" buttons point (your Fresha booking link).
- `links` -- the stack of link-in-bio buttons (set `primary: true` on one).
- `categories` -- the service menu, grouped by category.
- `hours` -- opening hours table.

To change the avatar, drop a square image at `static/images/logo.png` and set
`avatar: "/images/logo.png"` in `data/studio.yaml`.

## Local development

### Prerequisites

- [Hugo Extended](https://gohugo.io/getting-started/installing/) v0.148.2 or later
- [Git](https://git-scm.com/)

### Run it

```bash
git clone https://github.com/alisade/kapabeauty.com.git
cd kapabeauty.com
hugo server -D
```

Open [http://localhost:1313](http://localhost:1313). There is no theme
submodule to initialize -- the site is fully self-contained.

## Project structure

```
kapabeauty.com/
├── .github/workflows/hugo.yml    # GitHub Actions: build + deploy to Pages
├── data/studio.yaml              # ALL editable content lives here
├── layouts/
│   ├── index.html                # The landing page (standalone, no theme)
│   ├── 404.html                  # Branded 404 page
│   └── partials/svg-icon.html    # Inline icon set
├── content/_index.md             # Home page stub (metadata only)
├── static/                       # CNAME, robots.txt, images
├── terraform/                    # Cloudflare DNS (see below)
├── deploy-dns.sh                 # One-shot DNS deploy helper
└── hugo.toml                     # Site configuration
```

## Booking backend

The `/book/` page's booking system (availability, bookings, admin, anti-spam)
runs on a Cloudflare Worker + D1 database. That code lives in a **separate
private repo** (`alisade/labelle-booking`), not here. This site only needs the
deployed Worker URL, set as `bookingApiURL` in `data/studio.yaml`.

## Deployment

The site auto-deploys to GitHub Pages via GitHub Actions on every push to
`main` (`.github/workflows/hugo.yml`). No manual build step.

### GitHub Pages setup (one time)

1. Repo Settings -> Pages
2. Source: "GitHub Actions"
3. Custom domain: `labellenailstudio.com`, then enable "Enforce HTTPS"

### Custom domain / DNS

The custom domain is set via `static/CNAME` (published to the site root as
`CNAME`). DNS is managed in Cloudflare through Terraform:

```bash
./deploy-dns.sh
```

This decrypts the Cloudflare API token from `cloudflare.ansible.vault`, then
runs `terraform plan` / `apply` in `terraform/` to create the GitHub Pages A /
AAAA records for `labellenailstudio.com`. See `terraform/README.md` for details.

## License

MIT -- see [LICENSE](LICENSE).
