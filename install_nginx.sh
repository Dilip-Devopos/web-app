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

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
    echo "AWS CLI not found. Installing AWS CLI..."
    sudo apt update
    sudo apt install -y unzip curl
    curl "https://d1uj6qtbmh3dt5.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Download the zip file from S3
echo "Downloading zip file from S3..."
aws s3 cp s3://$S3_BUCKET/$ZIP_FILE /tmp/$ZIP_FILE --profile $AWS_PROFILE

# Create a directory to extract the zip file
echo "Creating directory for extracted files..."
mkdir -p $EXTRACT_DIR

# Extract the zip file
echo "Extracting zip file..."
unzip /tmp/$ZIP_FILE -d $EXTRACT_DIR

# Verify that the HTML file exists
if [ ! -f "$EXTRACT_DIR/$HTML_FILE" ]; then
    echo "Error: $HTML_FILE not found in the extracted files."
    exit 1
fi

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
