FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["Calculator.Client/Calculator.Client.csproj", "Calculator.Client/"]
RUN dotnet restore "Calculator.Client/Calculator.Client.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "Calculator.Client/Calculator.Client.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Calculator.Client/Calculator.Client.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/runtime:10.0 AS final

# Add image metadata and labels
LABEL maintainer="Calculator.Grpc Team"
LABEL description="Calculator gRPC Client - Interactive console client for Calculator gRPC service"
LABEL version="1.0.0"
LABEL application="Calculator.Grpc.Client"
LABEL component="client"
LABEL framework="dotnet9.0"
LABEL protocol="grpc"

WORKDIR /app

# Create non-root user for security
RUN groupadd -r calculator && useradd -r -g calculator calculator

# Copy published app
COPY --from=publish /app/publish .

# Set ownership and permissions
RUN chown -R calculator:calculator /app
USER calculator

# Set environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV SERVER_URL=http://calculator-server:5002

ENTRYPOINT ["dotnet", "Calculator.Client.dll"]
