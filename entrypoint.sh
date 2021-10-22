#!/bin/sh -l

set -e

BASE64_PATTERN="(ewo|eyJ|YTo|Tzo|PD[89]|aHR0cHM6L|aHR0cDo|rO0)[a-zA-Z0-9+/]+={0,2}"

if [ -z "$FIREBASE_TOKEN" ] && [ -z "$GCP_SA_KEY" ]; then
  echo "Either FIREBASE_TOKEN or GCP_SA_KEY is required to run commands with the firebase cli"
  exit 126
fi

if [ -n "$GCP_SA_KEY" ]; then
  # If encoded base64 key, decode and save
  if [[ "$GCP_SA_KEY" =~ $BASE64_PATTERN ]]; then
    echo "Storing and decodeding GCP_SA_KEY in /opt/gcp_key.json"
    echo "$GCP_SA_KEY" | base64 -d > /opt/gcp_key.json
  else
    echo "Storing GCP_SA_KEY in /opt/gcp_key.json"
    echo "$GCP_SA_KEY" > /opt/gcp_key.json
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

sh -c "firebase $*"
