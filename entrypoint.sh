#!/bin/sh -l

set -e

if [ -z "$FIREBASE_TOKEN" ] && [ -z "$GCP_SA_KEY" ]; then
  echo "Either FIREBASE_TOKEN or GCP_SA_KEY is required to run commands with the firebase cli"
  exit 126
fi

if [ -n "$GCP_SA_KEY" ]; then
  echo "Storing GCP_SA_KEY in /opt/gcp_key.json"
  CHECK_ENCODING=$(echo "$GCP_SA_KEY" | base64 -d &>/dev/null; echo $?)
  if [ "$CHECK_ENCODING" -ne 0 ]; then
    echo "Error: GCP_SA_KEY must be base64 encoded."
    exit 1
  fi
  echo "$GCP_SA_KEY" | base64 -d > /opt/gcp_key.json
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
