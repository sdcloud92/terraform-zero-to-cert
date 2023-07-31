#!/bin/bash
# Update the package manager and install Apache HTTP server
sudo yum update -y
sudo yum install -y httpd

# Create the index.html file with "Hello, World!" content
echo "<h1>Hello, World!</h1>" | sudo tee /var/www/html/index.html

# Start and enable Apache HTTP server
sudo systemctl start httpd
sudo systemctl enable httpd

