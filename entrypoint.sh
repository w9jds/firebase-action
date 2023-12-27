#!/bin/bash

set -e

if [ -z "$FIREBASE_TOKEN" ] && [ -z "$GCP_SA_KEY" ] && [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
  echo "Either FIREBASE_TOKEN or GCP_SA_KEY or GOOGLE_APPLICATION_CREDENTIALS is required to run commands with the firebase cli"
  exit 126
fi

if [ -n "$GCP_SA_KEY" ]; then
  if echo "$GCP_SA_KEY" | jq empty 2>/dev/null; then
    echo "Storing GCP_SA_KEY in /opt/gcp_key.json"
    echo "$GCP_SA_KEY" > /opt/gcp_key.json
  else
    echo "Storing the decoded GCP_SA_KEY in /opt/gcp_key.json"
    echo "$GCP_SA_KEY" | base64 -d > /opt/gcp_key.json # If encoded base64 key, decode and save
  fi

  echo "Exporting GOOGLE_APPLICATION_CREDENTIALS=/opt/gcp_key.json"
  export GOOGLE_APPLICATION_CREDENTIALS=/opt/gcp_key.json
fi

if [ -n "$PROJECT_PATH" ]; then
  cd "$PROJECT_PATH"
fi

if [ -n "$PROJECT_ID" ]; then
    echo "setting firebase project to $PROJECT_ID"
    firebase use --add "$PROJECT_ID"
fi

if [ -n "$CONFIG_VALUES" ]; then
    echo "Setting config for function"
    firebase functions:config:set $CONFIG_VALUES
fi

sh -c "firebase $*"

# response=$(firebase $*)

# if [ $? -eq 0 ]; then
#   echo "$response"
#   exit 0
# else
#   echo "$response"
#   exit 1
# fi
