#!/usr/bin/env bash

set -euo pipefail


echo "============================================================"
echo " Godot 4.7.2 C++ GDExtension Project Verification"
echo "============================================================"


# ============================================================
# PROJECT FILES
# ============================================================

required_files=(

    "project/project.godot"

    "project/main.tscn"

    "project/bin/aoi_native.gdextension"

    "src/aoi_native.cpp"

    "src/aoi_native.h"

    "SConstruct"

    "custom.py"

    "methods.py"

    ".gitmodules"

)


echo ""
echo "[1/6] Checking required files..."


for file in "${required_files[@]}"; do

    if [[ ! -f "$file" ]]; then

        echo ""
        echo "ERROR: Missing file:"
        echo "       $file"

        exit 1

    fi

    echo "OK: $file"

done


# ============================================================
# GODOT-CPP
# ============================================================

echo ""
echo "[2/6] Checking godot-cpp..."


if [[ ! -d "godot-cpp" ]]; then

    echo ""
    echo "ERROR: godot-cpp directory does not exist."
    echo ""
    echo "This means the Git submodule was NOT initialized."
    echo ""

    echo "Run locally:"
    echo ""
    echo "  git submodule sync --recursive"
    echo "  git submodule update --init --recursive"
    echo ""

    exit 1

fi


if [[ ! -f "godot-cpp/SConstruct" ]]; then

    echo ""
    echo "ERROR: godot-cpp directory exists but is empty/incomplete."
    echo ""

    exit 1

fi


echo "OK: godot-cpp/SConstruct"


# ============================================================
# GDEXTENSION
# ============================================================

echo ""
echo "[3/6] Checking GDExtension configuration..."


GDEXTENSION="project/bin/aoi_native.gdextension"


grep -q \
    'entry_symbol = "aoi_native_library_init"' \
    "$GDEXTENSION"


grep -q \
    'compatibility_minimum = "4.7"' \
    "$GDEXTENSION"


grep -q \
    'android.release.arm64' \
    "$GDEXTENSION"


grep -q \
    'libaoi_native.android.template_release.arm64.so' \
    "$GDEXTENSION"


echo "OK: GDExtension configuration"


# ============================================================
# C++ ENTRY POINT
# ============================================================

echo ""
echo "[4/6] Checking C++ entry point..."


grep -q \
    'aoi_native_library_init' \
    src/aoi_native.cpp


grep -q \
    'GDREGISTER_CLASS(AoiNative)' \
    src/aoi_native.cpp


echo "OK: C++ GDExtension entry point"


# ============================================================
# SCONS
# ============================================================

echo ""
echo "[5/6] Checking SCons build system..."


grep -q \
    'godot-cpp/SConstruct' \
    SConstruct


grep -q \
    'platform' \
    SConstruct


grep -q \
    'SharedLibrary' \
    SConstruct


echo "OK: SConstruct"


# ============================================================
# GIT SUBMODULE
# ============================================================

echo ""
echo "[6/6] Checking Git submodule configuration..."


grep -q \
    'path = godot-cpp' \
    .gitmodules


grep -q \
    'url = https://github.com/godotengine/godot-cpp.git' \
    .gitmodules


echo "OK: .gitmodules"


# ============================================================
# RESULT
# ============================================================

echo ""
echo "============================================================"
echo " VERIFICATION PASSED"
echo "============================================================"

echo ""
echo "Godot:"
echo "  4.7.2"

echo ""
echo "GDExtension API:"
echo "  4.7"

echo ""
echo "Platform:"
echo "  Android"

echo ""
echo "Architecture:"
echo "  ARM64 / arm64-v8a"

echo ""
echo "Target:"
echo "  template_release"

echo ""
echo "Precision:"
echo "  single"

echo ""
echo "Expected output:"
echo "  project/bin/android/"
echo "  libaoi_native.android.template_release.arm64.so"

echo ""
