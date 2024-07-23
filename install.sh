#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y nginx docker.io net-tools jq

# Create log file
sudo touch /var/log/devopsfetch.log
sudo chmod 644 /var/log/devopsfetch.log

# Setup systemd service
cat <<EOL | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOpsFetch Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service