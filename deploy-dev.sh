#!/bin/bash
set -e

# =========================
# Path setup
# =========================
INFRA_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$INFRA_DIR/.." && pwd)"
ORCH_DIR="$ROOT_DIR/orchestrator"
AI_DIR="$ROOT_DIR/ai-engine"

echo "📂 Base dir: $BASE_DIR"

# =========================
# .env check
# =========================
if [ ! -f "$INFRA_DIR/.env" ]; then
  echo "❌ .env file not found"
  exit 1
fi

if [ ! -f "$INFRA_DIR/.env.sample" ]; then
  echo "❌ .env.sample file not found"
  exit 1
fi

echo "🔍 Checking .env variables..."

REQUIRED_KEYS=$(grep -vE '^\s*#|^\s*$' "$INFRA_DIR/.env.sample" | cut -d= -f1)
MISSING=0

for key in $REQUIRED_KEYS; do
  if ! grep -q "^$key=" "$INFRA_DIR/.env"; then
    echo "❌ Missing env var: $key"
    MISSING=1
  fi
done

if [ $MISSING -eq 1 ]; then
  echo "🚫 .env validation failed"
  exit 1
fi

echo "✅ .env validation passed"

# =========================
# Git pull
# =========================
echo "📦 Pull orchestrator"
cd "$ORCH_DIR"
git pull origin dev

echo "📦 Pull ai-engine"
cd "$AI_DIR"
git pull origin dev

# =========================
# Docker compose
# =========================
echo "🚀 Docker compose up"
cd "$INFRA_DIR"
docker compose up -d --build

echo "🎉 Deploy completed successfully"
