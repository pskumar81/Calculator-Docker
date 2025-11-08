#!/bin/bash

# Bash script to build Calculator.Grpc Docker images with consistent naming
# Usage: ./build-docker-images.sh

echo "🏗️  Building Calculator.Grpc Docker Images..."
echo ""

# Set consistent image names (Docker requires lowercase)
SERVER_IMAGE="calculator.grpc.server"
CLIENT_IMAGE="calculator.grpc.client"
VERSION="latest"

# Build Server Image
echo "📦 Building $SERVER_IMAGE..."
docker build -t "${SERVER_IMAGE}:${VERSION}" -f Calculator.Server/Dockerfile .
if [ $? -ne 0 ]; then
    echo "❌ Server image build failed!"
    exit 1
fi

# Build Client Image
echo "📦 Building $CLIENT_IMAGE..."
docker build -t "${CLIENT_IMAGE}:${VERSION}" -f Calculator.Client/Dockerfile .
if [ $? -ne 0 ]; then
    echo "❌ Client image build failed!"
    exit 1
fi

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📋 Created Images:"
docker images | grep "calculator.grpc"
echo ""

echo "🚀 Usage Commands:"
echo "  Server: docker run -d -p 5002:5002 --name calculator-grpc-server $SERVER_IMAGE"
echo "  Client: docker run -it --rm --name calculator-grpc-client -e SERVER_URL=\"http://host.docker.internal:5002\" $CLIENT_IMAGE"
echo ""
echo "🐳 Container Management:"
echo "  Stop Server: docker stop calculator-grpc-server"
echo "  Remove Server: docker rm calculator-grpc-server" 
echo "  View Logs: docker logs calculator-grpc-server"