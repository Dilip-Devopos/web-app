#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt-get update -y

# Install NGINX
echo "Installing NGINX..."
sudo apt-get install nginx -y

# Start the NGINX service
echo "Starting NGINX service..."
sudo systemctl start nginx

# Enable NGINX to start on boot
echo "Enabling NGINX to start on boot..."
sudo systemctl enable nginx

# Verify NGINX installation
echo "Checking NGINX status..."
sudo systemctl status nginx

echo "NGINX installation completed."
