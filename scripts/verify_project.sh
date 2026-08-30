#!/usr/bin/env bash

set -euo pipefail

echo "============================================================"
echo " Godot 4.7.2 C++ GDExtension Verification"
echo "============================================================"

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
        echo "ERROR: Missing:"
        echo "  $file"

        exit 1

    fi

    echo "OK: $file"

done


echo ""
echo "[2/5] Checking C++ source..."

grep -q \
    "aoi_native_library_init" \
    src/aoi_native.cpp

grep -q \
    "GDREGISTER_CLASS(AoiNative)" \
    src/aoi_native.cpp

echo "OK: C++ source"


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


echo ""
echo "[4/5] Checking SConstruct..."

grep -q \
    "godot-cpp/SConstruct" \
    SConstruct

grep -q \
    "SharedLibrary" \
    SConstruct

echo "OK: SConstruct"


echo ""
echo "[5/5] Checking build configuration..."

grep -q \
    "platform" \
    SConstruct

grep -q \
    "target" \
    SConstruct

grep -q \
    "precision" \
    SConstruct

echo "OK: build configuration"


echo ""
echo "============================================================"
echo " PROJECT VERIFICATION PASSED"
echo "============================================================"

echo ""
echo "godot-cpp will be downloaded automatically by GitHub Actions."
echo "" 
