# Calculator Web Client

This is an Angular web client that consumes the gRPC Calculator service.

## Features

- **Two Input Fields**: Enter two numbers for calculation
- **Four Operations**: Add, Subtract, Multiply, and Divide
- **Submit Button**: Performs the selected operation
- **Clear Button**: Clears all input fields and results
- **Result Display**: Shows the calculation result
- **Error Handling**: Displays errors for invalid operations (e.g., division by zero)
- **Loading State**: Shows loading indicator during calculations

## Getting Started

### Running with Docker (Recommended)

1. Build and run the entire application stack:
   ```bash
   docker-compose up --build
   ```

2. Access the web client at: http://localhost:4200
3. The gRPC server will be running at: http://localhost:5001

### Running Locally (Development)

1. Install Node.js dependencies:
   ```bash
   cd Calculator.Web
   npm install
   ```

2. Start the development server:
   ```bash
   npm start
   ```

3. Make sure the Calculator.Server is running on http://localhost:5001

## Usage

1. Open the web application in your browser
2. Enter the first number in the "First Number" field
3. Enter the second number in the "Second Number" field
4. Click one of the operation buttons:
   - **Add (+)**: Adds the two numbers
   - **Subtract (-)**: Subtracts the second number from the first
   - **Multiply (×)**: Multiplies the two numbers
   - **Divide (÷)**: Divides the first number by the second
5. View the result in the result section
6. Use the **Clear** button to reset all fields

## Architecture

- **Angular 17**: Frontend framework
- **gRPC-Web**: Protocol for browser-to-server communication
- **TypeScript**: Type-safe development
- **Reactive Forms**: For form handling and validation
- **RxJS**: For reactive programming and async operations

## gRPC-Web Integration

The web client communicates with the .NET gRPC server using gRPC-Web protocol, which allows browsers to make gRPC calls. The server has been configured to support both HTTP/1.1 and HTTP/2 protocols with CORS enabled.

## Error Handling

- Input validation ensures both fields contain valid numbers
- Division by zero is handled gracefully
- Network errors are caught and displayed to the user
- Fallback mock calculations are provided for demonstration

## Development Notes

- The TypeScript proto files are manually created for this demo
- In a production environment, use protoc with grpc-web plugin to generate client code
- The service includes fallback mock calculations for offline development