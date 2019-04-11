#!/bin/bash
if [[ $1 == User* ]]; then
  echo "$GITHUB_USERNAME"
else
  echo "$GITHUB_PASSWORD"
fi
