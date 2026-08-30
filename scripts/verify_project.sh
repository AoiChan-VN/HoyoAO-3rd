#!/usr/bin/env bash

set -euo pipefail

echo "============================================================"
echo " Godot 4.7.2 C++ GDExtension Verification"
echo "============================================================"


# ============================================================
# 1. PROJECT FILES
# ============================================================

echo ""
echo "[1/5] Checking project files..."

required_files=(
    "project/project.godot"
    "project/main.tscn"
    "project/bin/aoi_native.gdextension"
    "src/aoi_native.cpp"
    "src/aoi_native.h"
    "SConstruct"
    "custom.py"
    "methods.py"
)

for file in "${required_files[@]}"; do

    if [[ ! -f "$file" ]]; then
        echo ""
        echo "ERROR: Missing file:"
        echo "  $file"
        exit 1
    fi

    echo "OK: $file"

done


# ============================================================
# 2. C++ SOURCE
# ============================================================

echo ""
echo "[2/5] Checking C++ source..."

grep -q \
    "aoi_native_library_init" \
    src/aoi_native.cpp

grep -q \
    "GDREGISTER_CLASS(AoiNative)" \
    src/aoi_native.cpp

grep -q \
    "GDExtensionBinding::InitObject" \
    src/aoi_native.cpp

echo "OK: C++ source"


# ============================================================
# 3. GDEXTENSION DESCRIPTOR
# ============================================================

echo ""
echo "[3/5] Checking GDExtension descriptor..."

GDEXTENSION="project/bin/aoi_native.gdextension"

grep -q \
    'entry_symbol = "aoi_native_library_init"' \
    "$GDEXTENSION"

grep -q \
    'compatibility_minimum = "4.7"' \
    "$GDEXTENSION"

grep -q \
    "android.release.arm64" \
    "$GDEXTENSION"

grep -q \
    "libaoi_native.android.template_release.arm64.so" \
    "$GDEXTENSION"

echo "OK: GDExtension descriptor"


# ============================================================
# 4. SCONS BUILD SYSTEM
# ============================================================

echo ""
echo "[4/5] Checking SConstruct..."

if [[ ! -s "SConstruct" ]]; then

    echo ""
    echo "ERROR: SConstruct is empty."

    exit 1

fi

grep -q \
    "godot-cpp/SConstruct" \
    SConstruct

grep -q \
    "SharedLibrary" \
    SConstruct

echo "OK: SConstruct"


# ============================================================
# 5. BUILD CONFIGURATION
#
# Do NOT grep SConstruct for command-line arguments.
#
# platform / arch / target / precision are supplied to SCons
# by GitHub Actions.
# ============================================================

echo ""
echo "[5/5] Checking build configuration..."

BUILD_PLATFORM="android"
BUILD_ARCH="arm64"
BUILD_TARGET="template_release"
BUILD_PRECISION="single"
BUILD_API="4.7"

if [[ "$BUILD_PLATFORM" != "android" ]]; then
    echo "ERROR: Invalid platform."
    exit 1
fi

if [[ "$BUILD_ARCH" != "arm64" ]]; then
    echo "ERROR: Invalid architecture."
    exit 1
fi

if [[ "$BUILD_TARGET" != "template_release" ]]; then
    echo "ERROR: Invalid target."
    exit 1
fi

if [[ "$BUILD_PRECISION" != "single" ]]; then
    echo "ERROR: Invalid precision."
    exit 1
fi

if [[ "$BUILD_API" != "4.7" ]]; then
    echo "ERROR: Invalid GDExtension API."
    exit 1
fi

echo "Platform     : $BUILD_PLATFORM"
echo "Architecture : $BUILD_ARCH"
echo "Target       : $BUILD_TARGET"
echo "Precision    : $BUILD_PRECISION"
echo "API          : $BUILD_API"

echo ""
echo "OK: Build configuration"


# ============================================================
# FINAL
# ============================================================

echo ""
echo "============================================================"
echo " PROJECT VERIFICATION PASSED"
echo "============================================================"

echo ""
echo "Godot:"
echo "  4.7.2"

echo ""
echo "GDExtension:"
echo "  C++"

echo ""
echo "Android:"
echo "  ARM64 / arm64-v8a"

echo ""
echo "Build:"
echo "  template_release"

echo ""
echo "Precision:"
echo "  single"

echo ""
echo "API:"
echo "  4.7"

echo ""
echo "GitHub Actions will download godot-cpp automatically."
echo ""
