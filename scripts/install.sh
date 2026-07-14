#!/usr/bin/env bash
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-global}"

if [[ "$MODE" == "project" ]]; then
  BASE="$(pwd)/.grok"
  echo "Install mode: PROJECT -> $BASE"
else
  BASE="${HOME}/.grok"
  echo "Install mode: GLOBAL -> $BASE"
fi

SKILLS="$BASE/skills"
COMMANDS="$BASE/commands"
DST="$SKILLS/strix"

mkdir -p "$SKILLS" "$COMMANDS" "$DST"
cp -R "$KIT_ROOT/skills/strix/." "$DST/"
echo "  skill: strix"

for f in "$KIT_ROOT"/commands/*.md; do
  cp -f "$f" "$COMMANDS/"
  echo "  command: $(basename "$f")"
done

echo ""
echo "Wrapper installed. Install Strix CLI separately (Docker + LLM key)."
echo "  https://docs.strix.ai"
echo "Try: /strix-status | /strix-scan ."
