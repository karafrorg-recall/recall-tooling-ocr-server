# Stage 1: Build with Bazel
FROM ubuntu:22.04 AS builder

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    git \
    build-essential \
    python3 \
    zip \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Bazelisk (Bazel version manager) - handles architecture automatically
ARG TARGETARCH
RUN curl -L "https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-${TARGETARCH}" -o /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel

# Set up working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Build the application with Bazel
# Using --sandbox_writable_path to work around sandbox issues in Docker
RUN bazel build //cmd/recal_tooling_ocr_server:recal_tooling_ocr_server \
    --jobs=auto \
    --compilation_mode=opt

# Stage 2: Runtime image
FROM ubuntu:22.04 AS runtime

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies (minimal)
RUN apt-get update && apt-get install -y \
    libpng16-16 \
    zlib1g \
    libstdc++6 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m -s /bin/bash appuser

# Create app directory
WORKDIR /app

# Copy the built binary and its runfiles from builder
COPY --from=builder /app/bazel-bin/cmd/recal_tooling_ocr_server/recal_tooling_ocr_server_/recal_tooling_ocr_server /app/recal_tooling_ocr_server
COPY --from=builder /app/bazel-bin/cmd/recal_tooling_ocr_server/recal_tooling_ocr_server_/recal_tooling_ocr_server.runfiles /app/recal_tooling_ocr_server.runfiles

# Set ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set environment variables for tessdata
# The tessdata is located in the runfiles directory
ENV TESSDATA_PREFIX=/app/recal_tooling_ocr_server.runfiles/_main/external/+tessdata_deps+tessdata_eng/file

# Expose port (if needed for server mode in future)
EXPOSE 8080

# Run the application
ENTRYPOINT ["/app/recal_tooling_ocr_server"]

