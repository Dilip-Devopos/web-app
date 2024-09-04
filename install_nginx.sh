#!/bin/bash

# Set variables
S3_BUCKET="dilip-bucket-14"
ZIP_FILE="deployment-package.zip"
EXTRACT_DIR="/tmp/deployment-package"
HTML_FILE="index.html"
NGINX_HTML_DIR="/var/www/html"

# Function to check if NGINX is installed and install if not
install_nginx() {
    if systemctl status nginx &>/dev/null; then
        echo "NGINX is already installed."
    else
        echo "Installing NGINX..."
        sudo apt update
        sudo apt install -y nginx
    fi
}

# Function to check if AWS CLI is installed and install if not
install_aws_cli() {
    if ! command -v aws &>/dev/null; then
        echo "AWS CLI not found. Installing AWS CLI..."
        sudo apt update
        sudo apt install -y curl unzip
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
    fi
}

# Function to configure AWS CLI with credentials from Jenkins
configure_aws_cli() {
    # Assuming AWS credentials are configured as environment variables by Jenkins
    if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "AWS credentials are not set."
        exit 1
    fi
    aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set region "$AWS_REGION"
}

# Main script execution
echo "Starting deployment script..."

# Install NGINX
install_nginx

# Stop NGINX before updating content
echo "Stopping NGINX server..."
sudo systemctl stop nginx

# Install AWS CLI if not installed
install_aws_cli

# Configure AWS CLI
configure_aws_cli

# Download the zip file from S3
echo "Downloading zip file from S3..."
aws s3 cp s3://$S3_BUCKET/$ZIP_FILE /tmp/$ZIP_FILE

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
