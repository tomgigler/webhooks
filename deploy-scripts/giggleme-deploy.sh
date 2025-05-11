#!/bin/bash
set -euo pipefail

source /var/www/webhooks/.env

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add $SSH_KEY_PATH

LOGFILE="/var/www/html/giggletest/deploy-test.log"
TEST_DIR="/var/www/html/giggletest"
PROD_DIR="/var/www/html/GiggleMe"
REPO_DIR="$TEST_DIR/.git"

# Read GitHub webhook JSON payload from stdin
read_payload=$(cat)

# Log the raw payload
echo "$(date): Raw payload: $read_payload" >> "$LOGFILE"

# Extract branch name
branch=$(echo "$read_payload" | grep -oE '"ref"\s*:\s*"refs/heads/[^"]+"' | sed -E 's/.*"refs\/heads\/([^"]+)"/\1/')

# Log the branch
if [ -z "$branch" ]; then
  echo "$(date): No branch found in payload" >> "$LOGFILE"
  exit 1
else
  echo "$(date): Branch pushed: $branch" >> "$LOGFILE"
fi

# Pull the branch into the test directory
echo "$(date): Pulling $branch into $TEST_DIR" >> "$LOGFILE"
cd "$TEST_DIR"
git fetch origin "$branch" >> "$LOGFILE" 2>&1
git checkout "$branch" >> "$LOGFILE" 2>&1
git pull origin "$branch" >> "$LOGFILE" 2>&1

# Deploy to production if it's the main branch
if [ "$branch" = "main" ]; then
  echo "$(date): Deploying to production at $PROD_DIR" >> "$LOGFILE"

  git archive --format=tar HEAD:web | tar -x -C /var/www/html/GiggleMe/

  echo "$(date): Production deploy complete." >> "$LOGFILE"
else
  echo "$(date): Not main branch — production deploy skipped." >> "$LOGFILE"
fi

exit 0
