#!/bin/bash
set -e

# Download Flutter (supports Dart >=3.9.0)
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Fix git safe directory warning
git config --global --add safe.directory /vercel/path0/flutter

# Enable web & get packages
flutter config --enable-web
flutter pub get

# Build web app
flutter build web
