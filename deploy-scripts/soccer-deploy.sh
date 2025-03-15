#!/bin/bash
cd /var/www/html/soccer || exit

source /var/www/webhooks/.env

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add $SSH_KEY_PATH

# Pull the latest changes
git fetch origin main
git reset --hard origin/main
