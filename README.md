# Calculator gRPC Service

A modern calculator implementation using gRPC for service communication in .NET 9.0. This project demonstrates how to build a distributed calculator service with client-server architecture using gRPC.

## Project Structure

- **Calculator.Server**: gRPC server implementation with calculator operations
  - Supports basic arithmetic operations (Add, Subtract, Multiply, Divide)
  - Includes input validation and error handling
  - Uses logging for operation tracking

- **Calculator.Client**: Console application that connects to the gRPC server
  - Demonstrates how to make gRPC calls to the server
  - Handles server responses and errors

- **Calculator.Tests**: Unit tests for the calculator service
  - Tests all arithmetic operations
  - Includes edge cases and error scenarios
  - Uses xUnit testing framework

## Features

- **Add Operation**: Adds two numbers
- **Subtract Operation**: Subtracts two numbers
- **Multiply Operation**: Multiplies two numbers
- **Divide Operation**: Divides two numbers (includes division by zero validation)

## Technical Details

- Built with .NET 9.0
- Uses gRPC for service communication
- Implements async/await pattern
- Includes proper error handling and logging
- Follows C# best practices

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/pskumar81/CalculatorGrpc.git
   ```

2. Build the solution:
   ```bash
   dotnet build
   ```

3. Run the server:
   ```bash
   cd Calculator.Server
   dotnet run
   ```

4. Run the client (in a new terminal):
   ```bash
   cd Calculator.Client
   dotnet run
   ```

## Testing

Run the tests using:
```bash
dotnet test
```

## Error Handling

- Division by zero throws a proper gRPC exception
- All operations are logged for monitoring and debugging
- Client handles server errors gracefully
