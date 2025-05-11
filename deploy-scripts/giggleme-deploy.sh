#!/bin/bash
source /var/www/webhooks/.env

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add $SSH_KEY_PATH

cd /var/www/html/giggletest || exit

git fetch origin working
git reset --hard origin/working
