#!/usr/bin/env bash
# =====================================================================
# HoyoAO-3rd — PHASE 0 STRUCTURE FREEZE SCAFFOLD
# Usage:  ./scaffold_structure.sh <monorepo_root> <aoi_cpp_root>
# Law:    COMPLETE FILE > PATCH FRAGMENT — chạy xong commit ngay.
# =====================================================================
set -euo pipefail

MONO_ROOT="${1:?Usage: scaffold_structure.sh <monorepo_root> <aoi_cpp_root>}"
CPP_ROOT="${2:?Thiếu đường dẫn aoi-cpp root}"

make_dirs() {
  local root="$1"; shift
  local d
  for d in "$@"; do
    mkdir -p "$root/$d"
    touch "$root/$d/.gitkeep"
  done
}

# ---------- 1. MONOREPO: ENGINE-AGNOSTIC LAYER ----------
make_dirs "$MONO_ROOT" \
  "native" \
  "data/schema" \
  "data/defs_src/characters" "data/defs_src/weapons" "data/defs_src/skills" \
  "data/defs_src/items" "data/defs_src/enemies" "data/defs_src/stages" \
  "data/defs_src/gacha" "data/defs_src/quality" \
  "data/content/manifests" "data/content/packages" \
  "data/locales/en" "data/locales/vi" "data/locales/zh" \
  "data/cfg/defaults" "data/cfg/quality" \
  "tools/data_compiler" "tools/manifest_validator" \
  "tools/save_inspector" "tools/ci_scripts" \
  "engines/godot" "engines/unity" "engines/unreal" \
  "docs/architecture" "docs/pipeline" "docs/audit" \
  "ci" ".github/workflows"

# ---------- 2. GODOT PRESENTER PROJECT (res://) ----------
GODOT_RES="$MONO_ROOT/engines/godot/project"
make_dirs "$GODOT_RES" \
  "app/boot" "app/lifecycle" "app/router" \
  "sys/bridge" "sys/commands" "sys/event_bus" "sys/services" "sys/telemetry" \
  "cfg/defaults" "cfg/quality" \
  "defs/characters" "defs/weapons" "defs/skills" "defs/items" \
  "defs/enemies" "defs/stages" "defs/gacha" "defs/quality" \
  "content/manifests" "content/packages" "content/ownership" "content/patches" \
  "gameplay/intent" "gameplay/state" "gameplay/camera" "gameplay/flow" "gameplay/debug" \
  "combat/view" "combat/hitfx" "combat/reaction" "combat/debug" \
  "char/models" "char/anim" "char/rig" "char/presets" \
  "fx/vfx_pool" "fx/materials" "fx/shaders" "fx/overdraw" \
  "ui/hud" "ui/lobby" "ui/settings" "ui/console" "ui/debug" \
  "save/import" "save/export" "save/quarantine" \
  "locales/en" "locales/vi" "locales/zh" \
  "docs/architecture" \
  "addons/aoi_cpp/bin/android" "addons/aoi_cpp/bin/windows" \
  "addons/aoi_cpp/bin/linux" "addons/aoi_cpp/gdextension"

# ---------- 3. NATIVE REPO aoi-cpp ----------
make_dirs "$CPP_ROOT" \
  "include/aoi/core/dcl" "include/aoi/core/ids" "include/aoi/core/schema" \
  "include/aoi/core/clock" "include/aoi/core/result" \
  "include/aoi/crypto" "include/aoi/save_vault" "include/aoi/econ" \
  "include/aoi/owner_console" "include/aoi/quality_governor" \
  "include/aoi/combat_sim" "include/aoi/content_domain" \
  "src/core/dcl" "src/core/ids" "src/core/schema" "src/core/clock" "src/core/result" \
  "src/crypto" "src/save_vault" "src/econ" "src/owner_console" \
  "src/quality_governor" "src/combat_sim" "src/content_domain" \
  "src/gdext_boundary" \
  "third_party" \
  "tests/unit" "tests/golden" "tests/fuzz" \
  "tools/save_inspector" \
  "cmake/presets" "docs" ".github/workflows"

echo "[DONE] Structure frozen."
echo "NEXT:  1) git submodule add https://github.com/AoiChan-VN/aoi-cpp native/aoi-cpp"
echo "       2) cd native/aoi-cpp && git submodule add -b 4.7.2-stable https://github.com/godotengine/godot-cpp third_party/godot-cpp"
echo "       3) Bắt đầu Phase 1 — DCL Foundation (aoi-cpp/src/core + gdext_boundary skeleton)." 
