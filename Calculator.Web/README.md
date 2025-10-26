# Calculator Angular Web Client

A modern Angular web client for the Calculator gRPC Service. This package provides a complete web interface for performing arithmetic operations through gRPC-Web protocol.

## Features

- ✅ **Modern Angular 17** application with TypeScript
- ✅ **gRPC-Web Integration** for browser-compatible gRPC communication
- ✅ **Responsive Design** that works on desktop and mobile
- ✅ **Real-time Validation** with user-friendly error handling
- ✅ **Arithmetic Operations**: Add, Subtract, Multiply, Divide
- ✅ **Clean UI** with Material Design principles

## Installation

```bash
npm install @calculator/web-client
```

## Usage

### Development Server

```bash
npm start
```

Navigate to `http://localhost:4200/` to use the calculator.

### Production Build

```bash
npm run build:prod
```

The build artifacts will be stored in the `dist/` directory.

### Docker Deployment

```bash
docker build -t calculator-web .
docker run -p 4200:80 calculator-web
```

## Configuration

The web client expects the gRPC server to be running on `http://localhost:5002` by default. You can configure this by modifying the `serverUrl` in the calculator service.

## API

The web client communicates with the Calculator gRPC Server using the following operations:

- **Add**: Adds two numbers
- **Subtract**: Subtracts the second number from the first
- **Multiply**: Multiplies two numbers
- **Divide**: Divides the first number by the second (with division by zero protection)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Dependencies

### Runtime Dependencies
- `@angular/core`: Angular framework
- `@angular/forms`: Reactive forms support
- `grpc-web`: gRPC-Web client library
- `google-protobuf`: Protocol Buffers support

### Development Dependencies
- `@angular/cli`: Angular CLI
- `typescript`: TypeScript compiler
- `@angular-devkit/build-angular`: Angular build system

## Development

### Prerequisites
- Node.js 18+
- npm 8+

### Setup
```bash
git clone https://github.com/pskumar81/Calculator-Docker.git
cd Calculator-Docker/Calculator.Web
npm install
npm start
```

### Testing
```bash
npm test
npm run test:ci  # For CI environment
```

### Building
```bash
npm run build:prod
```

## Docker Support

The package includes Docker support for containerized deployment:

```dockerfile
FROM nginx:alpine
COPY dist/calculator-web /usr/share/nginx/html
EXPOSE 80
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see the [LICENSE](https://github.com/pskumar81/Calculator-Docker/blob/master/LICENSE) file for details.

## Support

- 📚 [Documentation](https://github.com/pskumar81/Calculator-Docker)
- 🐛 [Issues](https://github.com/pskumar81/Calculator-Docker/issues)
- 💬 [Discussions](https://github.com/pskumar81/Calculator-Docker/discussions)