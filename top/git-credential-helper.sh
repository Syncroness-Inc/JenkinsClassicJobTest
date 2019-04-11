#!/bin/bash
echo "args=$@." >> tmp.txt
if [[ $1 == User* ]]; then
  echo "$GITHUB_USERNAME"
  echo "$GITHUB_USERNAME" >> tmp.txt
else
  echo "$GITHUB_PASSWORD"
  echo "$GITHUB_PASSWORD" >> tmp.txt
fi
