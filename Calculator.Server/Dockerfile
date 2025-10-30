FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["Calculator.Server/Calculator.Server.csproj", "Calculator.Server/"]
RUN dotnet restore "Calculator.Server/Calculator.Server.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "Calculator.Server/Calculator.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Calculator.Server/Calculator.Server.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

# Create non-root user for security
RUN groupadd -r calculator && useradd -r -g calculator calculator

# Copy published app
COPY --from=publish /app/publish .

# Set ownership and permissions
RUN chown -R calculator:calculator /app
USER calculator

# Expose port
EXPOSE 5002

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5002/health || exit 1

# Configure environment for Azure
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:5002

ENTRYPOINT ["dotnet", "Calculator.Server.dll"]
