#!/usr/bin/env pwsh

# PowerShell script to build Calculator.Grpc Docker images with consistent naming
# Usage: .\build-docker-images.ps1

Write-Host "🏗️  Building Calculator.Grpc Docker Images..." -ForegroundColor Cyan
Write-Host ""

# Set consistent image names (Docker requires lowercase)
$SERVER_IMAGE = "calculator.grpc.server"
$CLIENT_IMAGE = "calculator.grpc.client"
$VERSION = "latest"

# Build Server Image
Write-Host "📦 Building $SERVER_IMAGE..." -ForegroundColor Green
docker build -t "${SERVER_IMAGE}:${VERSION}" -f Calculator.Server/Dockerfile .
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Server image build failed!"
    exit 1
}

# Build Client Image
Write-Host "📦 Building $CLIENT_IMAGE..." -ForegroundColor Green
docker build -t "${CLIENT_IMAGE}:${VERSION}" -f Calculator.Client/Dockerfile .
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Client image build failed!"
    exit 1
}

Write-Host ""
Write-Host "✅ Build completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Created Images:" -ForegroundColor Cyan
docker images | Select-String "Calculator.Grpc"
Write-Host ""

Write-Host "🚀 Usage Commands:" -ForegroundColor Yellow
Write-Host "  Server: docker run -d -p 5002:5002 --name calc-server $SERVER_IMAGE" -ForegroundColor White
Write-Host "  Client: docker run -it --rm -e SERVER_URL=`"http://host.docker.internal:5002`" $CLIENT_IMAGE" -ForegroundColor White