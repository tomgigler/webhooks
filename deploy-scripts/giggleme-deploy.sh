#!/bin/bash

set -xe

read_payload=$(cat)
output_file="/var/www/html/giggletest/deploy-test.log"

# Log the raw payload for debugging
echo "$(date): Raw payload: $read_payload" >> "$output_file"

# Extract the branch name using grep + sed
branch=$(echo "$read_payload" | grep -oE '"ref"\s*:\s*"refs/heads/[^"]+"' | sed -E 's/.*"refs\/heads\/([^"]+)"/\1/')

# Log the result
if [ -z "$branch" ]; then
	  echo "$(date): No branch found in payload" >> "$output_file"
  else
	    echo "$(date): Branch pushed: $branch" >> "$output_file"
    fi

