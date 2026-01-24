#!/bin/bash

set -e

missing=0

for key in $(grep -v '^#' .env.sample | cut -d= -f1); do
  if ! grep -q "^$key=" .env; then
    echo "❌ Missing env: $key"
    missing=1
  fi
done

if [ $missing -eq 1 ]; then
  echo "환경변수 누락 있음. 배포 중단."
  exit 1
fi

echo "✅ 모든 필수 환경변수 존재"
