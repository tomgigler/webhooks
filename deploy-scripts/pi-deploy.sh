#!/bin/bash
cd /var/www/html/pi || exit

# Pull the latest changes
git fetch origin main
git reset --hard origin/main
