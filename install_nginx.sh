#!/bin/bash

# Set variables
S3_BUCKET="dilip-bucket-14"
ZIP_FILE="deployment-package.zip"
EXTRACT_DIR="/tmp/deployment-package"
HTML_FILE="index.html"
NGINX_HTML_DIR="/var/www/html"
AWS_PROFILE="default"  # Change if you use a different AWS profile

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

# Download the zip file from S3
echo "Downloading zip file from S3..."
aws s3 cp s3://$S3_BUCKET/$ZIP_FILE /tmp/$ZIP_FILE --profile $AWS_PROFILE

# Create a directory to extract the zip file
echo "Creating directory for extracted files..."
mkdir -p $EXTRACT_DIR

# Extract the zip file
echo "Extracting zip file..."
unzip /tmp/$ZIP_FILE -d $EXTRACT_DIR

# Update the HTML file
echo "Updating HTML file..."
sudo cp $EXTRACT_DIR/$HTML_FILE $NGINX_HTML_DIR/$HTML_FILE

# Clean up
echo "Cleaning up temporary files..."
rm -rf $EXTRACT_DIR /tmp/$ZIP_FILE

# Start NGINX after updating content
echo "Starting NGINX server..."
sudo systemctl start nginx

echo "Deployment Complete!"
