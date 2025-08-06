# Kapa Beauty Website

A beautiful Hugo-based static website for Kapa Beauty, built with the PaperMod theme and deployed to GitHub Pages.

## 🌟 Features

- **Modern Design**: Clean, responsive design perfect for a beauty brand
- **Blog System**: Beauty tips and skincare advice
- **SEO Optimized**: Built-in SEO features and meta tags
- **Fast Loading**: Optimized for speed and performance
- **Mobile Responsive**: Looks great on all devices
- **Social Media Integration**: Easy social sharing and links

## 🚀 Quick Start

### Prerequisites

- [Hugo Extended](https://gohugo.io/getting-started/installing/) (v0.148.2 or later)
- [Git](https://git-scm.com/)

### Local Development

1. Clone the repository:
```bash
git clone https://github.com/[username]/kapabeauty.com.git
cd kapabeauty.com
```

2. Initialize the theme submodule:
```bash
git submodule update --init --recursive
```

3. Start the development server:
```bash
hugo server -D
```

4. Open your browser to [http://localhost:1313](http://localhost:1313)

## 📝 Content Management

### Adding Blog Posts

Create new blog posts in the `content/posts/` directory:

```bash
hugo new content posts/your-post-title.md
```

### Pages

Main pages are located in the `content/` directory:
- `_index.md` - Homepage
- `about.md` - About page
- `contact.md` - Contact page
- `shop.md` - Shop page

### Categories

Posts can be categorized using the `categories` frontmatter:
- `skincare` - Skincare tips and advice
- `makeup` - Makeup tutorials and tips

## 🎨 Customization

### Theme Configuration

The site uses the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme. Configuration is in `hugo.toml`.

### Styling

Custom CSS can be added in the `assets/css/` directory.

### Images

Add images to the `static/` directory. They'll be available at the root of your site.

## 🚢 Deployment

The site automatically deploys to GitHub Pages using GitHub Actions when you push to the main branch.

### Setup GitHub Pages

1. Go to your repository Settings
2. Navigate to Pages in the sidebar
3. Set Source to "GitHub Actions"
4. The workflow will run automatically on push

### Custom Domain

To use a custom domain:

1. Add a `CNAME` file to the `static/` directory with your domain
2. Configure your DNS to point to GitHub Pages

## 📁 Project Structure

```
kapabeauty.com/
├── .github/
│   └── workflows/
│       └── hugo.yml          # GitHub Actions deployment
├── archetypes/               # Content templates
├── assets/                   # SCSS, JS, images for processing
├── content/                  # Site content
│   ├── posts/               # Blog posts
│   ├── _index.md           # Homepage
│   ├── about.md            # About page
│   ├── contact.md          # Contact page
│   └── shop.md             # Shop page
├── data/                    # Data files
├── i18n/                    # Internationalization
├── layouts/                 # Custom layouts
├── static/                  # Static files (images, favicon, etc.)
├── themes/                  # Hugo themes
│   └── PaperMod/           # PaperMod theme (submodule)
└── hugo.toml               # Site configuration
```

## 🛠️ Development

### Adding New Features

1. Create a new branch for your feature
2. Make your changes
3. Test locally with `hugo server -D`
4. Submit a pull request

### Theme Updates

To update the PaperMod theme:

```bash
git submodule update --remote themes/PaperMod
```

## 📧 Support

For questions or support, please [open an issue](https://github.com/[username]/kapabeauty.com/issues) or contact us at hello@kapabeauty.com.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Hugo](https://gohugo.io/) - Static site generator
- [PaperMod](https://github.com/adityatelange/hugo-PaperMod) - Hugo theme
- [GitHub Pages](https://pages.github.com/) - Hosting platform

---

**Built with ❤️ for Kapa Beauty**
