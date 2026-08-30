#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PRIMARY_REF="$(cat godot_cpp_ref | tr -d '\r')"

FALLBACK_REFS=(
  "godot-4.7.2-stable"
  "godot-4.7-stable"
  "godot-4.7"
)

if [ -f godot-cpp/SConstruct ]; then
  echo "godot-cpp already present."
  exit 0
fi

try_clone_ref() {
  local ref="$1"

  rm -rf godot-cpp
  echo "Trying godot-cpp ref: $ref"

  if git clone --depth 1 --branch "$ref" https://github.com/godotengine/godot-cpp.git godot-cpp; then
    return 0
  fi

  rm -rf godot-cpp

  if git clone https://github.com/godotengine/godot-cpp.git godot-cpp; then
    cd godot-cpp
    if git checkout "$ref"; then
      cd ..
      return 0
    fi
    cd ..
  fi

  rm -rf godot-cpp
  return 1
}

if try_clone_ref "$PRIMARY_REF"; then
  exit 0
fi

for ref in "${FALLBACK_REFS[@]}"; do
  if try_clone_ref "$ref"; then
    echo "WARNING: using fallback godot-cpp ref: $ref"
    exit 0
  fi
done

echo "Unable to clone godot-cpp. Set native/extension/godot_cpp_ref to a valid ref." >&2
exit 1 
