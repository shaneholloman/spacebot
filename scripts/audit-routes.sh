#!/usr/bin/env bash
# Extracts all API routes from the frontend client and backend handlers,
# then diffs them to find mismatches.
#
# Usage: ./scripts/audit-routes.sh

set -euo pipefail
cd "$(dirname "$0")/.."

FRONTEND_FILE="interface/src/api/client.ts"
BACKEND_DIR="src/api"

extract_frontend_routes() {
  # Two patterns to catch:
  # 1. fetchJson<...>("/<path>")  — relative paths
  # 2. `${getApiBase()}/<path>`   — template literal paths
  {
    # Pattern 1: fetchJson("/path...")
    grep -oE 'fetchJson<[^>]*>\([^)]*"(/[^"?]+)' "$FRONTEND_FILE" \
      | grep -oE '"/[^"?]+' \
      | sed 's/^"//'

    # Pattern 2: ${getApiBase()}/path...`
    grep -oE 'getApiBase\(\)\}/[^`"]+' "$FRONTEND_FILE" \
      | sed 's|getApiBase()}||'
  } \
    | sed 's|\?.*||' \
    | sed 's/\${[^}]*}/{param}/g' \
    | sed '/^\s*$/d' \
    | sort -u
}

extract_backend_routes() {
  grep -ohE 'path\s*=\s*"(/[^"]+)"' "$BACKEND_DIR"/*.rs \
    | sed 's/.*path *= *"//' \
    | sed 's/".*//' \
    | sed 's/{[^}]*}/{param}/g' \
    | sort -u
}

echo "=== Frontend routes ==="
echo ""
extract_frontend_routes | while read -r route; do
  printf "  %s\n" "$route"
done

echo ""
echo "=== Backend routes ==="
echo ""
extract_backend_routes | while read -r route; do
  printf "  %s\n" "$route"
done

FRONTEND_ROUTES=$(mktemp)
BACKEND_ROUTES=$(mktemp)
trap 'rm -f "$FRONTEND_ROUTES" "$BACKEND_ROUTES"' EXIT

extract_frontend_routes > "$FRONTEND_ROUTES"
extract_backend_routes > "$BACKEND_ROUTES"

echo ""
echo "=== Mismatches ==="
echo ""

missing=0
while read -r route; do
  if ! grep -qF "$route" "$BACKEND_ROUTES"; then
    if [ $missing -eq 0 ]; then
      echo "Frontend routes with NO matching backend route:"
    fi
    echo "  ❌ $route"
    missing=$((missing + 1))
  fi
done < "$FRONTEND_ROUTES"

if [ $missing -eq 0 ]; then
  echo "✅ All frontend routes have a matching backend route."
fi
