# Build stage
FROM node:25-alpine AS build

WORKDIR /app

# Copy package files
COPY Calculator.Web/package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY Calculator.Web/ ./

# Build the application
RUN npm run build

# Serve stage
FROM nginx:alpine

# Copy built application
COPY --from=build /app/dist/calculator-web /usr/share/nginx/html

# Copy nginx configuration
COPY Calculator.Web/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]