# Local AI QA Engineer - PowerShell Launch & Diagnostics Script

Write-Host "==========================================================" -ForegroundColor Cyans
Write-Host "🚀 Launching Local AI QA Engineer Stack..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Verify Docker Installation
Write-Host "🔍 Checking Docker Desktop status..." -ForegroundColor Yellow
docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker is not running or not installed! Please start Docker Desktop first." -ForegroundColor Red
    Exit 1
}
Write-Host "✅ Docker Desktop is running." -ForegroundColor Green

# 2. Check Ollama Host Connection
Write-Host "🔍 Checking local Ollama endpoint (http://localhost:11434)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -TimeoutSec 3
    Write-Host "✅ Ollama is online!" -ForegroundColor Green
    if ($response.models.Count -eq 0) {
        Write-Host "⚠️ No local Ollama models found!" -ForegroundColor Yellow
        Write-Host "💡 Recommended action: Run 'ollama pull qwen2.5-coder' or 'ollama pull llama3.2' in another terminal." -ForegroundColor Cyan
    } else {
        Write-Host "📦 Available Ollama models:" -ForegroundColor Cyan
        foreach ($m in $response.models) {
            Write-Host "   - $($m.name)" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "⚠️ Warning: Could not connect to local Ollama at http://localhost:11434." -ForegroundColor Yellow
    Write-Host "   Ensure Ollama is installed and running ('ollama serve')." -ForegroundColor Gray
}

# 3. Spin up Docker Containers
Write-Host "`n📦 Starting Docker Compose services (LibreChat, Playwright MCP, MongoDB)..." -ForegroundColor Yellow
docker compose up -d --build

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host "🎉 Local AI QA Engineer stack is successfully running!" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "🌐 LibreChat UI:        http://localhost:3080" -ForegroundColor BrightWhite
    Write-Host "🤖 Playwright MCP SSE:   http://localhost:8931/sse" -ForegroundColor BrightWhite
    Write-Host "🗄️ MongoDB Database:     mongodb://localhost:27017" -ForegroundColor BrightWhite
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "👉 Open http://localhost:3080 in your browser to start QA testing!" -ForegroundColor Yellow
} else {
    Write-Host "❌ Docker Compose failed to start containers. Check logs above." -ForegroundColor Red
}
