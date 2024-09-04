#!/bin/bash

# Check if NGINX is already installed
if systemctl status nginx &>/dev/null; then
    echo "NGINX is already installed."
else
    echo "Installing NGINX..."
    sudo apt update
    sudo apt install -y nginx
fi

# Stop NGINX before updating content
echo "Stopping NGINX server..."
sudo systemctl stop nginx

# Update the HTML file
sudo cp /tmp/index.html /var/www/html/index.html

# Start NGINX after updating content
echo "Starting NGINX server..."
sudo systemctl start nginx

echo "Deployment Complete!"
