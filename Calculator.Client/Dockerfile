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

FROM mcr.microsoft.com/dotnet/runtime:9.0 AS final
WORKDIR /app

# Create non-root user for security
RUN groupadd -r calculator && useradd -r -g calculator calculator

# Copy published app
COPY --from=publish /app/publish .

# Set ownership and permissions
RUN chown -R calculator:calculator /app
USER calculator

# Configure environment for Azure
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "Calculator.Client.dll"]
