#!/usr/bin/env bash
# =====================================================================
# ENGINE FIREWALL CHECK — aoi-cpp
# LAW: C++ core (mọi thứ NGOẠI TRỪ src/gdext_boundary/) không được
#      include bất kỳ header godot/gdextension nào.
# Owner: C++ Core Directorate | Chạy trong: .github/workflows/firewall.yml
# =====================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

VIOLATIONS=0
while IFS= read -r f; do
  if grep -nE '#[[:space:]]*include[[:space:]]*[<"](godot|gdextension)' "$f" >/dev/null 2>&1; then
    echo "[FIREWALL VIOLATION] $f"
    grep -nE '#[[:space:]]*include[[:space:]]*[<"](godot|gdextension)' "$f"
    VIOLATIONS=$((VIOLATIONS + 1))
  fi
done < <(find include src -type f \( -name '*.h' -o -name '*.hpp' -o -name '*.cpp' \) \
          -not -path 'src/gdext_boundary/*' 2>/dev/null)

if [ "$VIOLATIONS" -ne 0 ]; then
  echo "[RESULT] FAIL — $VIOLATIONS violation(s)."
  echo "         C++ CORE PHẢI ENGINE-AGNOSTIC. Chỉ gdext_boundary được chạm godot-cpp."
  exit 1
fi

echo "[RESULT] PASS — engine firewall intact (core is engine-free)." 
