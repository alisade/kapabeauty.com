# GitHub Pages Deployment Setup Instructions

Follow these steps to deploy your Kapa Beauty website to GitHub Pages:

## 1. Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and create a new repository
2. Name it `kapabeauty.com` (or any name you prefer)
3. Make it public (required for GitHub Pages on free accounts)
4. Do NOT initialize with README, .gitignore, or license (we already have these)

## 2. Push Your Code to GitHub

```bash
# Add your GitHub repository as origin (replace USERNAME with your GitHub username)
git remote add origin https://github.com/USERNAME/kapabeauty.com.git

# Push your code to GitHub
git branch -M main
git push -u origin main
```

## 3. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on **Settings** tab
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select **GitHub Actions**
5. The workflow will automatically run and deploy your site

## 4. Configure Custom Domain (Optional)

If you own the domain `kapabeauty.com`:

1. In your repository **Settings** → **Pages**
2. Under **Custom domain**, enter `kapabeauty.com`
3. Check **Enforce HTTPS**
4. Configure your DNS provider to point to GitHub Pages:
   - Add a CNAME record pointing `www.kapabeauty.com` to `USERNAME.github.io`
   - Add A records for `kapabeauty.com` pointing to:
     - `185.199.108.153`
     - `185.199.109.153`
     - `185.199.110.153`
     - `185.199.111.153`

## 5. Monitor Deployment

1. Go to the **Actions** tab in your repository
2. You'll see the "Deploy Hugo Site to GitHub Pages" workflow running
3. Once complete (green checkmark), your site will be live at:
   - `https://USERNAME.github.io/kapabeauty.com` (default)
   - `https://kapabeauty.com` (if custom domain is configured)

## 6. Update Content

To add new blog posts or update content:

1. Make changes locally
2. Test with `hugo server -D`
3. Commit and push:
   ```bash
   git add .
   git commit -m "Add new blog post"
   git push
   ```
4. GitHub Actions will automatically rebuild and deploy

## Troubleshooting

### If deployment fails:
1. Check the Actions tab for error messages
2. Ensure all content files have `draft = false` in frontmatter
3. Verify the theme submodule is properly committed

### To update the theme:
```bash
git submodule update --remote themes/PaperMod
git add themes/PaperMod
git commit -m "Update PaperMod theme"
git push
```

### To add new blog posts:
```bash
hugo new content posts/your-new-post.md
# Edit the file and set draft = false
git add .
git commit -m "Add new blog post"
git push
```

## Features Included

✅ **Responsive Design** - Works on all devices  
✅ **SEO Optimized** - Meta tags, structured data  
✅ **Fast Loading** - Optimized images and minified code  
✅ **Blog System** - Beauty tips and skincare advice  
✅ **Social Media Integration** - Share buttons and links  
✅ **Contact Forms** - Ready for integration  
✅ **Search Functionality** - Built-in site search  
✅ **Analytics Ready** - Easy Google Analytics setup  

## Next Steps

1. **Content**: Add more blog posts and product information
2. **Images**: Add your logo and product images to the `static/` folder
3. **Analytics**: Add your Google Analytics ID to `hugo.toml`
4. **Contact Form**: Integrate with Formspree, Netlify Forms, or similar
5. **E-commerce**: Consider integrating with Shopify, WooCommerce, or Snipcart

Your beautiful Kapa Beauty website is ready to go live! 🚀✨
