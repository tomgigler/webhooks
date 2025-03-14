#!/bin/bash

# Define variables
WEBHOOK_DIR="/var/www/webhooks"
SERVICE_FILE="/etc/systemd/system/webhook.service"
SSH_KEY_PATH="/home/www-data/.ssh/id_rsa"  # Adjust this if needed

# Install dependencies
sudo apt update && sudo apt install -y python3-pip apache2
pip3 install flask

# Move the webhook repository to the correct location
sudo rm -rf $WEBHOOK_DIR
sudo cp -r . $WEBHOOK_DIR
sudo chmod -R 755 $WEBHOOK_DIR
sudo chown -R www-data:www-data $WEBHOOK_DIR

# Start SSH agent and add the key
echo "🔐 Enter the passphrase for the webhook's SSH key:"
eval "$(ssh-agent -s)"
ssh-add $SSH_KEY_PATH

# Install systemd service
sudo cp webhook.service $SERVICE_FILE
sudo systemctl daemon-reload
sudo systemctl enable webhook.service
sudo systemctl restart webhook.service

echo "✅ Webhook service deployed and running!"
