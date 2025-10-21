# Contributing to Calculator gRPC Service

Thank you for your interest in contributing to the Calculator gRPC Service! This document provides guidelines and information for contributors.

## 🚀 Quick Start

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/your-username/Calculator-Docker.git`
3. **Create** a feature branch: `git checkout -b feature/your-feature-name`
4. **Make** your changes
5. **Test** your changes locally
6. **Commit** with a clear message: `git commit -m "feat: add new feature"`
7. **Push** to your fork: `git push origin feature/your-feature-name`
8. **Create** a pull request

## 🔄 CI/CD Pipeline

Our automated CI/CD pipeline will:
- ✅ Run all tests (.NET and Angular)
- ✅ Build Docker images
- ✅ Perform security scans
- ✅ Check code quality
- ✅ Auto-label your PR
- ✅ Welcome new contributors

## 📋 Pull Request Guidelines

### Before Submitting
- [ ] Code follows project conventions
- [ ] All tests pass locally
- [ ] Documentation is updated if needed
- [ ] Commit messages follow conventional commits format

### PR Title Format
Use conventional commit format:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test additions/modifications
- `chore:` - Maintenance tasks

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings introduced
```

## 🧪 Testing

### Local Testing
```bash
# Test .NET components
dotnet test Calculator.Tests/

# Test Angular components
cd Calculator.Web
npm test

# Test Docker builds
docker-compose up --build
```

### Automated Testing
- **Unit Tests**: .NET xUnit tests
- **Integration Tests**: Docker Compose validation
- **Security Tests**: CodeQL and Trivy scans
- **Quality Tests**: SonarCloud analysis

## 🏗️ Development Environment

### Prerequisites
- .NET 9.0 SDK
- Node.js 18+
- Docker Desktop
- Git

### Setup
```bash
# Clone repository
git clone https://github.com/pskumar81/Calculator-Docker.git
cd Calculator-Docker

# Restore .NET dependencies
dotnet restore

# Install Angular dependencies
cd Calculator.Web
npm install
cd ..

# Run with Docker
docker-compose up --build
```

## 📦 Release Process

1. **Create Release**: Tag with semantic version (e.g., `v1.2.0`)
2. **Automated Build**: GitHub Actions builds and publishes Docker images
3. **Container Registry**: Images published to `ghcr.io/pskumar81/calculator-docker-*`
4. **Documentation**: Release notes auto-generated

## 🛡️ Security

- Report security vulnerabilities privately via GitHub Security tab
- Use latest base images and dependencies
- Follow security best practices
- Regular automated security scans

## 📞 Support

- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Documentation**: Check README.md and .github/WORKFLOWS.md

## 🏷️ Labels

We use these labels for organization:
- `bug` - Bug reports
- `enhancement` - Feature requests
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `server` - Backend/gRPC server related
- `client` - Console client related
- `web` - Angular web client related
- `docker` - Docker/containerization related
- `ci/cd` - CI/CD pipeline related

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## 🎉 Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes
- Project documentation

Thank you for contributing! 🚀