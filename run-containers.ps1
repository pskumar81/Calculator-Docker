#!/usr/bin/env pwsh

# PowerShell script to manage Calculator.Grpc containers with consistent naming
# Usage: .\run-containers.ps1 [start|stop|restart|status|logs]

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "cleanup", "client")]
    [string]$Action = "start"
)

# Container configuration
$SERVER_IMAGE = "calculator.grpc.server:latest"
$CLIENT_IMAGE = "calculator.grpc.client:latest"
$SERVER_CONTAINER = "calculator-grpc-server"
$CLIENT_CONTAINER = "calculator-grpc-client"
$NETWORK_NAME = "calculator-grpc-network"

function Start-Client {
    Write-Host "💻 Starting Calculator Client..." -ForegroundColor Green
    
    # Check if server is running
    $serverRunning = docker ps -q --filter name=$SERVER_CONTAINER
    if (-not $serverRunning) {
        Write-Error "❌ Server container '$SERVER_CONTAINER' is not running. Please start the server first with: .\run-containers.ps1 start"
        return
    }
    
    # Check if network exists
    $networkExists = docker network ls --filter name=$NETWORK_NAME --format "{{.Name}}" | Where-Object { $_ -eq $NETWORK_NAME }
    if (-not $networkExists) {
        Write-Error "❌ Network '$NETWORK_NAME' does not exist. Please start the server first with: .\run-containers.ps1 start"
        return
    }
    
    Write-Host "🔗 Connecting to server: http://${SERVER_CONTAINER}:5002" -ForegroundColor Cyan
    Write-Host "📡 Using network: $NETWORK_NAME" -ForegroundColor Cyan
    Write-Host ""
    
    # Run client interactively
    docker run -it --rm `
        --name $CLIENT_CONTAINER `
        --network $NETWORK_NAME `
        -e SERVER_URL="http://${SERVER_CONTAINER}:5002" `
        $CLIENT_IMAGE
}

function Start-Containers {
    Write-Host "🚀 Starting Calculator.Grpc Containers..." -ForegroundColor Green
    
    # Create network if it doesn't exist
    $networkExists = docker network ls --filter name=$NETWORK_NAME --format "{{.Name}}" | Where-Object { $_ -eq $NETWORK_NAME }
    if (-not $networkExists) {
        Write-Host "📡 Creating network: $NETWORK_NAME" -ForegroundColor Cyan
        docker network create $NETWORK_NAME
    }
    
    # Stop existing containers
    Stop-Containers -Silent
    
    # Start server
    Write-Host "🖥️  Starting server: $SERVER_CONTAINER" -ForegroundColor Yellow
    docker run -d `
        --name $SERVER_CONTAINER `
        --network $NETWORK_NAME `
        -p 5002:5002 `
        -e ASPNETCORE_ENVIRONMENT=Production `
        $SERVER_IMAGE
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Server started successfully!" -ForegroundColor Green
        Write-Host "   Container: $SERVER_CONTAINER"
        Write-Host "   Network: $NETWORK_NAME"
        Write-Host "   Port: http://localhost:5002"
        Write-Host ""
        
        Write-Host "ℹ️  To run client interactively:" -ForegroundColor Cyan
        Write-Host "   docker run -it --rm --name $CLIENT_CONTAINER --network $NETWORK_NAME -e SERVER_URL=`"http://${SERVER_CONTAINER}:5002`" $CLIENT_IMAGE"
    } else {
        Write-Error "❌ Failed to start server container"
    }
}

function Stop-Containers {
    param([switch]$Silent)
    
    if (-not $Silent) {
        Write-Host "🛑 Stopping Calculator.Grpc Containers..." -ForegroundColor Yellow
    }
    
    # Stop and remove containers
    docker stop $SERVER_CONTAINER 2>$null | Out-Null
    docker rm $SERVER_CONTAINER 2>$null | Out-Null
    docker stop $CLIENT_CONTAINER 2>$null | Out-Null
    docker rm $CLIENT_CONTAINER 2>$null | Out-Null
    
    if (-not $Silent) {
        Write-Host "✅ Containers stopped and removed" -ForegroundColor Green
    }
}

function Restart-Containers {
    Write-Host "🔄 Restarting Calculator.Grpc Containers..." -ForegroundColor Blue
    Stop-Containers -Silent
    Start-Sleep -Seconds 2
    Start-Containers
}

function Get-ContainerStatus {
    Write-Host "📊 Calculator.Grpc Container Status:" -ForegroundColor Cyan
    Write-Host ""
    
    # Check server
    $serverStatus = docker ps --filter name=$SERVER_CONTAINER --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    if ($serverStatus -and $serverStatus -ne "NAMES`tSTATUS`tPORTS") {
        Write-Host "🖥️  Server Status:" -ForegroundColor Green
        Write-Host $serverStatus
    } else {
        Write-Host "🖥️  Server: Not Running" -ForegroundColor Red
    }
    
    Write-Host ""
    
    # Check client
    $clientStatus = docker ps --filter name=$CLIENT_CONTAINER --format "table {{.Names}}\t{{.Status}}"
    if ($clientStatus -and $clientStatus -ne "NAMES`tSTATUS") {
        Write-Host "💻 Client Status:" -ForegroundColor Green
        Write-Host $clientStatus
    } else {
        Write-Host "💻 Client: Not Running" -ForegroundColor Red
    }
    
    Write-Host ""
    
    # Show network
    $networkExists = docker network ls --filter name=$NETWORK_NAME --format "{{.Name}}" | Where-Object { $_ -eq $NETWORK_NAME }
    if ($networkExists) {
        Write-Host "📡 Network: $NETWORK_NAME (Active)" -ForegroundColor Green
    } else {
        Write-Host "📡 Network: $NETWORK_NAME (Not Created)" -ForegroundColor Yellow
    }
}

function Show-Logs {
    Write-Host "📜 Container Logs:" -ForegroundColor Cyan
    Write-Host ""
    
    $serverRunning = docker ps -q --filter name=$SERVER_CONTAINER
    if ($serverRunning) {
        Write-Host "🖥️  Server Logs ($SERVER_CONTAINER):" -ForegroundColor Green
        docker logs --tail 20 $SERVER_CONTAINER
    } else {
        Write-Host "🖥️  Server container not running" -ForegroundColor Red
    }
    
    Write-Host ""
    
    $clientRunning = docker ps -q --filter name=$CLIENT_CONTAINER
    if ($clientRunning) {
        Write-Host "💻 Client Logs ($CLIENT_CONTAINER):" -ForegroundColor Green
        docker logs --tail 20 $CLIENT_CONTAINER
    } else {
        Write-Host "💻 Client container not running" -ForegroundColor Red
    }
}

function Cleanup-Environment {
    Write-Host "🧹 Cleaning up Calculator.Grpc environment..." -ForegroundColor Yellow
    
    Stop-Containers -Silent
    
    # Remove network
    $networkExists = docker network ls --filter name=$NETWORK_NAME --format "{{.Name}}" | Where-Object { $_ -eq $NETWORK_NAME }
    if ($networkExists) {
        docker network rm $NETWORK_NAME 2>$null | Out-Null
        Write-Host "✅ Network $NETWORK_NAME removed" -ForegroundColor Green
    }
    
    Write-Host "✅ Cleanup completed" -ForegroundColor Green
}

# Main execution
switch ($Action.ToLower()) {
    "start" { Start-Containers }
    "client" { Start-Client }
    "stop" { Stop-Containers }
    "restart" { Restart-Containers }
    "status" { Get-ContainerStatus }
    "logs" { Show-Logs }
    "cleanup" { Cleanup-Environment }
    default { 
        Write-Host "Usage: .\run-containers.ps1 [start|client|stop|restart|status|logs|cleanup]" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Commands:" -ForegroundColor Cyan
        Write-Host "  start   - Start server and create network"
        Write-Host "  client  - Start interactive client (server must be running)"
        Write-Host "  stop    - Stop and remove containers"
        Write-Host "  restart - Restart containers"
        Write-Host "  status  - Show container status"
        Write-Host "  logs    - Show container logs"
        Write-Host "  cleanup - Remove containers and network"
    }
}