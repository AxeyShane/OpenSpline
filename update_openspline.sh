#!/usr/bin/env bash
# ==============================================================================
# OpenSpline - Repo Housekeeping Script
#
# Applies the outstanding cleanup items:
#   1. Fix I_q / omega_z to render as proper HTML subscripts in README
#   2. Verify README's internal links point at files that actually exist
#   3. Set the repo About description + topics via gh CLI
#   4. (Optional) Wire up upstream dependencies -- see DEP_MODE below
#
# Run from inside the OpenSpline repo root.
# Requires: gh CLI, authenticated as AxeyShane (`gh auth switch --user AxeyShane`)
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# CONFIG: choose how upstream deps are wired in.
#   "none"      - do nothing (default; decide later)
#   "submodule" - add your forks as git submodules under third-party/
#                 Use this ONLY if you intend to MODIFY SimpleFOC/obi-esp32.
#   "platformio"- append lib_deps to platformio.ini (consume-as-is; recommended
#                 if you're just using SimpleFOC rather than patching it)
# ------------------------------------------------------------------------------
DEP_MODE=none

GH_USER="AxeyShane"
REPO="OpenSpline"

# Sanity check: are we in the right place?
if [ ! -f "README.md" ] || ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Run this from the root of the OpenSpline git repo."
  exit 1
fi

echo "🔧 OpenSpline housekeeping starting..."

# ------------------------------------------------------------------------------
# 1. Fix subscript rendering in README
# ------------------------------------------------------------------------------
echo "→ Fixing subscript rendering (I_q / ω_z)..."
if grep -q '(I_q)' README.md; then
  sed -i.bak 's/(I_q)/(I<sub>q<\/sub>)/g; s/(ω_z)/(ω<sub>z<\/sub>)/g' README.md
  rm -f README.md.bak
  echo "  ✅ Subscripts converted to inline HTML."
else
  echo "  ℹ️  No plain I_q found — already fixed or wording changed. Skipping."
fi

# ------------------------------------------------------------------------------
# 2. Verify README internal links resolve to real files
# ------------------------------------------------------------------------------
echo "→ Verifying README internal links..."
MISSING=0
for f in CONTRIBUTING.md LICENSE-MIT LICENSE-CC-BY docs/engineering_notebook.md; do
  if [ -f "$f" ]; then
    echo "  ✅ $f"
  else
    echo "  ⚠️  MISSING: $f  (README links to this — it will 404 on GitHub)"
    MISSING=$((MISSING + 1))
  fi
done

if [ "$MISSING" -gt 0 ]; then
  echo "  ℹ️  $MISSING file(s) missing. Re-run your init script, or remove the"
  echo "     corresponding links from README.md before pushing."
fi

# ------------------------------------------------------------------------------
# 3. Set About description + topics
# ------------------------------------------------------------------------------
echo "→ Setting repo description and topics..."

DESCRIPTION="Open hardware/firmware ecosystem replacing proprietary cordless tools with mass-produced BLDC motors, a shared 4-pin handshake, and 3D-printable parametric gearing."

gh repo edit "${GH_USER}/${REPO}" --description "$DESCRIPTION"

TOPICS=(
  power-tools
  open-hardware
  bldc-motor
  simplefoc
  esp32
  3d-printing
  parametric-cad
  firmware
  open-source-hardware
  motor-control
)

for t in "${TOPICS[@]}"; do
  gh repo edit "${GH_USER}/${REPO}" --add-topic "$t"
done
echo "  ✅ Description and ${#TOPICS[@]} topics applied."

# ------------------------------------------------------------------------------
# 4. Dependency wiring (opt-in)
# ------------------------------------------------------------------------------
case "$DEP_MODE" in
  submodule)
    echo "→ Adding forks as submodules under third-party/..."
    mkdir -p third-party
    git submodule add -f "https://github.com/${GH_USER}/Arduino-SimpleFOCShield.git" \
      third-party/Arduino-SimpleFOCShield
    git submodule add -f "https://github.com/${GH_USER}/obi-esp32.git" \
      third-party/obi-esp32
    echo "  ✅ Submodules added. Contributors must clone with --recursive."
    ;;
  platformio)
    echo "→ Appending SimpleFOC to platformio.ini lib_deps..."
    if [ -f platformio.ini ]; then
      echo "  ⚠️  platformio.ini already exists — not overwriting."
      echo "     Add this manually under your [env] section:"
      echo "       lib_deps = askuric/Simple FOC@^2.3.4"
    else
      cat > platformio.ini << 'PIOEOF'
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino

lib_deps =
    askuric/Simple FOC@^2.3.4
PIOEOF
      echo "  ✅ platformio.ini created with SimpleFOC dependency."
    fi
    ;;
  none)
    echo "→ Skipping dependency wiring (DEP_MODE=none)."
    echo "  ℹ️  Re-run with DEP_MODE=submodule or DEP_MODE=platformio once decided."
    ;;
  *)
    echo "❌ Unknown DEP_MODE: $DEP_MODE (expected: none|submodule|platformio)"
    exit 1
    ;;
esac

# ------------------------------------------------------------------------------
# 5. Commit and push
# ------------------------------------------------------------------------------
echo "→ Committing changes..."

if git diff --quiet && git diff --cached --quiet; then
  echo "  ℹ️  No file changes to commit (topics/description are applied via API)."
else
  git add -A
  git commit -m "chore: fix README subscript rendering and repo metadata

- Convert I_q / omega_z to inline HTML subscripts for correct GitHub rendering
- Housekeeping pass on repo description and topics"
  git push
  echo "  ✅ Pushed to main."
fi

echo ""
echo "✅ Done."
if [ "$MISSING" -gt 0 ]; then
  echo "⚠️  Reminder: $MISSING README link(s) point at files that don't exist yet."
fi