#!/bin/sh

set -e

if [ -z "$FIREBASE_TOKEN" ]; then
    echo "FIREBASE_TOKEN is required to run commands with the firebase cli"
    exit 126
fi

if [ -n "$PROJECT_ID" ]; then
    firebase use --add $PROJECT_ID
fi

sh -c "firebase $*"
