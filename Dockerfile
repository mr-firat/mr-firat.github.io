# Stage 1: Build the Docusaurus site
FROM node:22-alpine

WORKDIR /app

# Create Docusaurus project
RUN npx create-docusaurus@latest my-site classic --javascript

WORKDIR /app/my-site

# Install dependencies
RUN npm install

# Build the site
RUN npm run build

# Install git and openssh-client (for SSH key usage)
RUN apk add --no-cache git openssh-client bash

# Add your SSH private key into the container. 
# (This step assumes you have your private key ready as `id_rsa`)
COPY id_rsa /root/.ssh/id_rsa

# Set appropriate permissions for the SSH key
RUN chmod 600 /root/.ssh/id_rsa

# Configure SSH to avoid strict host checking for GitHub (to avoid prompt)
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n\n" > /root/.ssh/config

# Optionally, set your GitHub username and email for commits
RUN git config --global user.name "mr-firat" \
    && git config --global user.email "firatssonmez@gmail.com"

# Run your build or push commands
# Example of pushing changes to GitHub
RUN git init
RUN git remote add origin https://github.com/Mr-Firat/Mr-Firat.github.io.git 

# Install NGINX
RUN apk add --no-cache nginx

# Copy the build output to NGINX's default public folder
RUN cp -r build/* /var/lib/nginx/html/

# Expose port
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
