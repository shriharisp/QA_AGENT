#!/usr/bin/env bash

echo "=========================================================="
echo "🚀 Launching Local AI QA Engineer Stack..."
echo "=========================================================="

# 1. Verify Docker
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running or not installed! Please start Docker first."
    exit 1
fi
echo "✅ Docker is running."

# 2. Check Ollama
if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
    echo "✅ Ollama is online!"
else
    echo "⚠️ Warning: Could not connect to local Ollama at http://localhost:11434."
    echo "   Ensure Ollama is running ('ollama serve')."
fi

# 3. Spin up Docker Compose
echo ""
echo "📦 Starting Docker Compose services..."
docker compose up -d --build

if [ $? -eq 0 ]; then
    echo "=========================================================="
    echo "🎉 Local AI QA Engineer stack is running!"
    echo "=========================================================="
    echo "🌐 LibreChat UI:        http://localhost:3080"
    echo "🤖 Playwright MCP SSE:   http://localhost:8931/sse"
    echo "=========================================================="
else
    echo "❌ Failed to start Docker Compose services."
fi
