#!/bin/bash
set -e

echo "🚀 Deploy start"

BASE_DIR=$(pwd)

echo "📦 Pull orchestrator"
cd orchestrator
git pull
cd $BASE_DIR

echo "📦 Pull ai-engine"
cd ai-engine
git pull
cd $BASE_DIR

echo "🔍 Check env"
./check-env.sh

echo "🐳 Docker compose up"
docker compose up -d --build

echo "✅ Deploy complete"
