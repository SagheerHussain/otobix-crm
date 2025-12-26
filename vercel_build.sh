# vercel_build.sh - Vercel build script for OtoBix CRM
# This script is used by Vercel to build the Flutter web application
# It downloads Flutter, installs dependencies, and builds the web version

#!/bin/bash
set -e

# Download Flutter 3.35.5 (includes Dart >=3.9)
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.5-stable.tar.xz

# Extract Flutter
tar xf flutter_linux_3.35.5-stable.tar.xz

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Fix git safe directory warning
git config --global --add safe.directory /vercel/path0/flutter

# Enable web & install dependencies
flutter config --enable-web
flutter pub get

# # Build for web
# flutter build web


# Default if env missing in vercel - fallback to local development URL
: "${BASE_URL:=http://192.168.100.99:4000/api/}"

# Build for web
flutter build web --release --dart-define=BASE_URL="${BASE_URL}"

echo "BASE_URL during build = ${BASE_URL}"
