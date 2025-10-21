# GitHub Actions Workflow Status

This document contains information about the GitHub Actions workflows configured for this repository.

## Workflow Status Badges

### Main CI/CD Pipeline
[![CI/CD Pipeline](https://github.com/pskumar81/Calculator-Docker/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/pskumar81/Calculator-Docker/actions/workflows/ci-cd.yml)

### Pull Request Validation
[![Pull Request Validation](https://github.com/pskumar81/Calculator-Docker/actions/workflows/pr-validation.yml/badge.svg)](https://github.com/pskumar81/Calculator-Docker/actions/workflows/pr-validation.yml)

### Code Quality
[![Code Quality](https://github.com/pskumar81/Calculator-Docker/actions/workflows/code-quality.yml/badge.svg)](https://github.com/pskumar81/Calculator-Docker/actions/workflows/code-quality.yml)

### Release
[![Release](https://github.com/pskumar81/Calculator-Docker/actions/workflows/release.yml/badge.svg)](https://github.com/pskumar81/Calculator-Docker/actions/workflows/release.yml)

## Workflows Overview

### 1. **CI/CD Pipeline** (`ci-cd.yml`)
- **Triggers**: Push to master/main, Pull requests
- **Jobs**:
  - ✅ Test .NET Server
  - ✅ Test Angular Web Client
  - ✅ Build Docker Images
  - ✅ Integration Tests
  - ✅ Security Scan
  - ✅ Deploy to Production

### 2. **Pull Request Validation** (`pr-validation.yml`)
- **Triggers**: Pull requests to master/main
- **Jobs**:
  - ✅ Quick validation
  - ✅ Docker build test

### 3. **Code Quality** (`code-quality.yml`)
- **Triggers**: Push, Pull requests, Weekly schedule
- **Jobs**:
  - ✅ CodeQL Security Analysis
  - ✅ SonarCloud Analysis
  - ✅ Docker Lint

### 4. **Release** (`release.yml`)
- **Triggers**: Release published, Manual dispatch
- **Jobs**:
  - ✅ Build and push versioned Docker images
  - ✅ Create deployment manifests

### 5. **Dependabot** (`dependabot.yml`)
- **Schedule**: Weekly updates
- **Monitors**:
  - ✅ .NET NuGet packages
  - ✅ Angular npm packages
  - ✅ Docker base images
  - ✅ GitHub Actions

## Container Registry

Docker images are published to GitHub Container Registry (ghcr.io):

- `ghcr.io/pskumar81/calculator-docker-calculator-server`
- `ghcr.io/pskumar81/calculator-docker-calculator-web`
- `ghcr.io/pskumar81/calculator-docker-calculator-client`

## Secrets Required

To fully utilize all workflows, configure these secrets in your repository settings:

| Secret | Description | Required For |
|--------|-------------|--------------|
| `GITHUB_TOKEN` | Automatically provided | Docker registry, CodeQL |
| `SONAR_TOKEN` | SonarCloud authentication | Code quality analysis |

## Branch Protection

Recommended branch protection rules for `master` branch:
- ✅ Require status checks to pass
- ✅ Require pull request reviews
- ✅ Include administrators
- ✅ Restrict pushes