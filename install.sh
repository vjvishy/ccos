#!/bin/bash

# CCOS Installer — Install all Claude Code OS skills globally

set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing CCOS skills to $SKILLS_DIR..."

mkdir -p "$SKILLS_DIR"

for skill in "$SCRIPT_DIR"/skills/*.md; do
    filename=$(basename "$skill")
    cp "$skill" "$SKILLS_DIR/$filename"
    echo "  ✓ Installed $filename"
done

echo ""
echo "Done! CCOS skills are now available globally in Claude Code."
echo ""
echo "Quick start:"
echo "  rules:audit     — Score your CLAUDE.md"
echo "  brain:load      — Load context from last session"
echo "  brain:save      — Save context before closing"
echo ""
echo "Full docs: https://github.com/vjvishy/ccos"
