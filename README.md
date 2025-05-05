!CHATGPT generated!

# 🚀 Docusaurus GitHub Pages Deployment with Docker

This guide walks you through setting up a Docusaurus project using Docker, modifying the config files, authenticating with GitHub via SSH, and deploying to GitHub Pages.

---

## 🐳 Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/)
- A [GitHub repository](https://github.com/new) for your site
- Your SSH private key (`id_rsa`) copied into this folder

---

## 📁 Folder Structure

```
.
├── Dockerfile
├── id_rsa                # Your GitHub SSH private key (read-only, DO NOT COMMIT)
└── README.md
```

---

## 🛠️ Step-by-Step Instructions

### 1. Copy Your SSH Key

Place your SSH private key (`id_rsa`) in this folder. This is required for Git to push using SSH.

```bash
cp ~/.ssh/id_rsa ./id_rsa
chmod 400 id_rsa  # Secure the key
```

> ⚠️ **Do NOT commit `id_rsa` to GitHub!** Add it to `.gitignore`.

---

### 2. Build the Docker Image

```bash
docker build -t docusaurus-gh-pages .
```
Check the image with 
```bash
docker images
```
---

### 3. Run the Container

```bash
docker run docker run -d -p 80:80 docusaurus 
```

---

### 4. Configure `package.json` and `docusaurus.config.js`

Edit inside the Docker container after it starts.
**Change path to /app/my-site and install gh-pages**

```bash
npm install --save gh-pages
```

**Update `package.json`: add homepage in root node and deploy in scripts node**

```json
"homepage": "https://your-username.github.io/your-repo-name"
 "deploy": "gh-pages -d build",
```

**Update `docusaurus.config.js`:**

```js
url: "/your-repo-name/",
```

---

### 5. Initialize Git & Push

Inside the container:

```bash
git init
git remote add origin git@github.com:your-username/your-repo-name.git
```

---

### 6. Build and Deploy

Inside the container:

```bash
npm run build
npm run deploy
```

This deploys the site to the `gh-pages` branch.

---

## 🔍 GitHub Pages Configuration

1. Go to your repo's **Settings > Pages**
2. Set source to:
   - **Branch**: `gh-pages`
   - **Folder**: `/ (root)`

3. Save and visit your site at:

```
https://your-username.github.io/your-repo-name/
```

---

## 📝 Notes

- Use a **deploy key or personal SSH key with repo access**.
- To debug GitHub Pages issues, check the `gh-pages` branch contents.
- If deploying to the root (`your-username.github.io`), repo name **must** match that.

---

