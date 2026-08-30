#!/usr/bin/env bash
set -euo pipefail

test -f project/project.godot
test -f project/bin/aoi_native.gdextension
test -f src/aoi_native.cpp
test -f src/aoi_native.h
test -d godot-cpp

grep -q 'compatibility_minimum = "4.7"' project/bin/aoi_native.gdextension
grep -q 'android.release.arm64' project/bin/aoi_native.gdextension

echo "Project structure validation: OK"
