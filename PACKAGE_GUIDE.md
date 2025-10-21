# Package Guide

This document describes the packages created from the Calculator gRPC service project and how to use them.

## 📦 NuGet Packages

### Calculator.GrpcServer
**Package ID**: `Calculator.GrpcServer`  
**Version**: 1.0.0  
**Description**: A high-performance gRPC server implementation for calculator operations

#### Features
- Basic arithmetic operations (Add, Subtract, Multiply, Divide)
- gRPC and gRPC-Web protocol support
- Comprehensive error handling and validation
- Built-in logging and monitoring
- Division by zero protection
- Async/await pattern implementation

#### Installation
```bash
dotnet add package Calculator.GrpcServer
```

#### Usage
```csharp
using Calculator.Server.Services;
using Microsoft.AspNetCore.Server.Kestrel.Core;

var builder = WebApplication.CreateBuilder(args);

// Add gRPC services
builder.Services.AddGrpc();
builder.Services.AddGrpcReflection();
builder.Services.AddGrpcWeb(o => o.GrpcWebEnabled = true);

// Configure Kestrel for HTTP/2
builder.Services.Configure<KestrelServerOptions>(options =>
{
    options.ListenAnyIP(5001, o => o.Protocols = HttpProtocols.Http2);
});

var app = builder.Build();

// Configure gRPC pipeline
app.UseGrpcWeb();
app.MapGrpcService<CalculatorService>();
app.MapGrpcReflectionService();

app.Run();
```

### Calculator.GrpcClient
**Package ID**: `Calculator.GrpcClient`  
**Version**: 1.0.0  
**Description**: A gRPC client library for consuming calculator services

#### Features
- Easy-to-use client interface
- Dependency injection support
- Connection management
- Error handling and retry logic
- Async operation support

#### Installation
```bash
dotnet add package Calculator.GrpcClient
```

#### Usage
```csharp
using Calculator.Client.Services;
using Calculator.Client.Extensions;

// Register services
var services = new ServiceCollection();
services.AddCalculatorClient("https://localhost:5001");

var serviceProvider = services.BuildServiceProvider();
var calculatorClient = serviceProvider.GetRequiredService<ICalculatorClientService>();

// Use the client
try 
{
    var result = await calculatorClient.AddAsync(5, 3);
    Console.WriteLine($"5 + 3 = {result}");
    
    var difference = await calculatorClient.SubtractAsync(10, 4);
    Console.WriteLine($"10 - 4 = {difference}");
    
    var product = await calculatorClient.MultiplyAsync(6, 7);
    Console.WriteLine($"6 * 7 = {product}");
    
    var quotient = await calculatorClient.DivideAsync(15, 3);
    Console.WriteLine($"15 / 3 = {quotient}");
}
catch (RpcException ex)
{
    Console.WriteLine($"gRPC Error: {ex.Status.Detail}");
}
```

## 📦 npm Package

### @calculator/web
**Package Name**: `@calculator/web`  
**Version**: 1.0.0  
**Description**: Angular web client library for calculator services

#### Features
- Angular 17+ compatible
- gRPC-Web integration
- TypeScript support
- Reactive forms integration
- Error handling
- Responsive UI components

#### Installation
```bash
npm install @calculator/web
```

#### Usage

**1. Add to your Angular module:**
```typescript
import { CalculatorModule } from '@calculator/web';

@NgModule({
  imports: [
    CalculatorModule.forRoot({
      serverUrl: 'https://localhost:5001'
    })
  ]
})
export class AppModule { }
```

**2. Use in your component:**
```typescript
import { Component } from '@angular/core';
import { CalculatorService } from '@calculator/web';

@Component({
  selector: 'app-calculator',
  template: `
    <div class="calculator">
      <input [(ngModel)]="num1" type="number" placeholder="First number">
      <input [(ngModel)]="num2" type="number" placeholder="Second number">
      
      <button (click)="add()">Add</button>
      <button (click)="subtract()">Subtract</button>
      <button (click)="multiply()">Multiply</button>
      <button (click)="divide()">Divide</button>
      
      <div>Result: {{ result }}</div>
      <div *ngIf="error" class="error">{{ error }}</div>
    </div>
  `
})
export class CalculatorComponent {
  num1: number = 0;
  num2: number = 0;
  result: number | null = null;
  error: string | null = null;

  constructor(private calculatorService: CalculatorService) {}

  async add() {
    try {
      this.result = await this.calculatorService.add(this.num1, this.num2);
      this.error = null;
    } catch (error) {
      this.error = 'Addition failed';
    }
  }

  async subtract() {
    try {
      this.result = await this.calculatorService.subtract(this.num1, this.num2);
      this.error = null;
    } catch (error) {
      this.error = 'Subtraction failed';
    }
  }

  async multiply() {
    try {
      this.result = await this.calculatorService.multiply(this.num1, this.num2);
      this.error = null;
    } catch (error) {
      this.error = 'Multiplication failed';
    }
  }

  async divide() {
    try {
      this.result = await this.calculatorService.divide(this.num1, this.num2);
      this.error = null;
    } catch (error) {
      this.error = 'Division failed';
    }
  }
}
```

## 🛠️ Building Packages

### Prerequisites
- .NET 9.0 SDK
- Node.js 18+ (for npm packages)
- Cake build tool

### Build Commands

**Build all packages:**
```bash
dotnet cake build.cake --target=Pack
```

**Build specific packages:**
```bash
# .NET packages only
dotnet cake build.cake --target=Pack-Server
dotnet cake build.cake --target=Pack-Client

# npm package (requires Node.js)
dotnet cake build.cake --target=Pack-Web
```

**Full CI pipeline:**
```bash
dotnet cake build.cake --target=CI
```

### Package Locations
- NuGet packages: `artifacts/packages/*.nupkg`
- npm package: `Calculator.Web/dist/*.tgz`

## 🚀 Publishing Packages

### NuGet Packages
```bash
dotnet nuget push artifacts/packages/*.nupkg --source https://api.nuget.org/v3/index.json --api-key YOUR_API_KEY
```

### npm Package
```bash
cd Calculator.Web
npm publish --access public
```

## 📋 Package Dependencies

### Calculator.GrpcServer Dependencies
- Grpc.AspNetCore (>= 2.60.0)
- Grpc.AspNetCore.Web (>= 2.60.0)
- Microsoft.Extensions.Logging.Abstractions (>= 9.0.0)

### Calculator.GrpcClient Dependencies
- Grpc.Net.Client (>= 2.60.0)
- Google.Protobuf (>= 3.25.0)
- Microsoft.Extensions.DependencyInjection.Abstractions (>= 9.0.0)

### @calculator/web Dependencies
- @angular/core (>= 17.0.0)
- @angular/common (>= 17.0.0)
- grpc-web (>= 1.4.2)
- google-protobuf (>= 3.21.0)

## 🔧 Configuration

### Server Configuration
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Grpc": "Debug"
    }
  },
  "Kestrel": {
    "EndpointDefaults": {
      "Protocols": "Http2"
    }
  }
}
```

### Client Configuration
```json
{
  "CalculatorService": {
    "Endpoint": "https://localhost:5001",
    "Timeout": "00:00:30"
  }
}
```

## 📖 API Reference

### ICalculatorService (gRPC)
```protobuf
service Calculator {
  rpc Add(CalculationRequest) returns (CalculationResponse);
  rpc Subtract(CalculationRequest) returns (CalculationResponse);
  rpc Multiply(CalculationRequest) returns (CalculationResponse);
  rpc Divide(CalculationRequest) returns (CalculationResponse);
}

message CalculationRequest {
  double a = 1;
  double b = 2;
}

message CalculationResponse {
  double result = 1;
}
```

### ICalculatorClientService (C#)
```csharp
public interface ICalculatorClientService
{
    Task<double> AddAsync(double a, double b);
    Task<double> SubtractAsync(double a, double b);
    Task<double> MultiplyAsync(double a, double b);
    Task<double> DivideAsync(double a, double b);
}
```

### CalculatorService (TypeScript)
```typescript
export class CalculatorService {
  add(a: number, b: number): Promise<number>;
  subtract(a: number, b: number): Promise<number>;
  multiply(a: number, b: number): Promise<number>;
  divide(a: number, b: number): Promise<number>;
}
```

## 🔍 Troubleshooting

### Common Issues

**1. gRPC-Web CORS Issues**
Ensure your server is configured for CORS:
```csharp
app.UseCors(policy => 
  policy.AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader()
        .WithExposedHeaders("Grpc-Status", "Grpc-Message", "Grpc-Encoding", "Grpc-Accept-Encoding"));
```

**2. HTTP/2 Compatibility**
Some browsers require HTTPS for HTTP/2. Use development certificates:
```bash
dotnet dev-certs https --trust
```

**3. Division by Zero**
The service handles division by zero gracefully:
```csharp
if (request.B == 0)
{
    throw new RpcException(new Status(StatusCode.InvalidArgument, "Division by zero is not allowed"));
}
```

## 📝 Version History

### 1.0.0 (Initial Release)
- Basic arithmetic operations
- gRPC and gRPC-Web support
- .NET 9.0 compatibility
- Angular 17 support
- Comprehensive error handling
- Docker containerization
- CI/CD pipeline integration