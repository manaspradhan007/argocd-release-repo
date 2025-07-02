# Dockerfile for Nginx with Prometheus Exporter

# Stage 1: Build the Nginx Prometheus Exporter
FROM golang:1.22-alpine AS exporter-builder

WORKDIR /app

# Clone the Nginx Prometheus Exporter source code
# Using a specific release tag is recommended for stability
ARG EXPORTER_VERSION=1.2.0
RUN apk add --no-cache git && \
    git clone https://github.com/nginxinc/nginx-prometheus-exporter.git . && \
    git checkout tags/v${EXPORTER_VERSION}

# Build the exporter binary
RUN go mod tidy && \
    go build -o nginx-exporter .

# Stage 2: Build the final Nginx image
FROM nginx:1.25.4-alpine-slim

# Install curl for health checks (optional, but good practice)
# Install dos2unix to ensure correct line endings for the entrypoint script
RUN apk add --no-cache curl dos2unix

# Copy the built exporter binary from the builder stage
COPY --from=exporter-builder /app/nginx-exporter /usr/local/bin/nginx-exporter

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy the entrypoint script and ensure it has Unix line endings
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN dos2unix /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

# Expose Nginx HTTP port and Exporter metrics port
EXPOSE 9114
EXPOSE 80

# Set the custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]