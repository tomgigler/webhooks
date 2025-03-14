#!/bin/bash
cd /var/www/html/soccer || exit

# Pull the latest changes
git fetch origin main
git reset --hard origin/main
