#!/usr/bin/env bash
# Split an .epub file into individual chapter markdown files.
# Chapters are placed in sources/<subdir>/ ready for /ingest-source.
#
# Usage: ./scripts/split-epub.sh <epub-file> [subdir-name]
#
# Arguments:
#   epub-file    Path to the .epub file
#   subdir-name  Name of the subdirectory in sources/ (default: "chapters")
#
# Example:
#   ./scripts/split-epub.sh ~/Books/hologrammatica.epub chapters
#
# Requirements: pandoc (brew install pandoc)

set -euo pipefail

# --- Validate inputs ---

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <epub-file> [subdir-name]"
  echo "Example: $0 ~/Books/hologrammatica.epub chapters"
  exit 1
fi

EPUB_FILE="$1"
SUBDIR="${2:-chapters}"

if [[ ! -f "$EPUB_FILE" ]]; then
  echo "Error: file not found: $EPUB_FILE"
  exit 1
fi

if ! command -v pandoc &>/dev/null; then
  echo "Error: pandoc is required but not installed."
  echo "Install with: brew install pandoc"
  exit 1
fi

# --- Setup ---

SOURCES_DIR="sources/$SUBDIR"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

mkdir -p "$SOURCES_DIR"

echo "Converting $(basename "$EPUB_FILE") to markdown..."
pandoc "$EPUB_FILE" -t markdown -o "$TEMP_DIR/full.md" --wrap=none

# --- Split by H1 headers ---

CHAPTER_NUM=0
CURRENT_FILE=""
CURRENT_TITLE=""

while IFS= read -r line; do
  # Detect H1 header (# Title)
  if [[ "$line" =~ ^#\ (.+)$ ]]; then
    CHAPTER_NUM=$((CHAPTER_NUM + 1))
    CURRENT_TITLE="${BASH_REMATCH[1]}"

    # Create kebab-case filename from title
    SLUG=$(echo "$CURRENT_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9äöüß ]//g' | tr ' ' '-' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

    # Fallback if slug is empty
    if [[ -z "$SLUG" ]]; then
      SLUG="chapter-$(printf '%02d' "$CHAPTER_NUM")"
    fi

    CURRENT_FILE="$SOURCES_DIR/$SLUG.md"

    # Write frontmatter + header
    {
      echo "---"
      echo "type: source"
      echo "source: \"\""
      echo "date-ingested: $(date +%Y-%m-%d)"
      echo "---"
      echo ""
      echo "$line"
    } > "$CURRENT_FILE"

    echo "  $SLUG.md"
  elif [[ -n "$CURRENT_FILE" ]]; then
    echo "$line" >> "$CURRENT_FILE"
  fi
done < "$TEMP_DIR/full.md"

# --- Report ---

if [[ $CHAPTER_NUM -eq 0 ]]; then
  echo ""
  echo "Warning: no H1 headers found. The epub may use H2 or other markers."
  echo "The full markdown is at: $TEMP_DIR/full.md"
  echo "You may need to split it manually or adjust the script."
  # Don't delete temp dir on failure
  trap '' EXIT
  exit 1
fi

echo ""
echo "Done. $CHAPTER_NUM chapters written to $SOURCES_DIR/"
echo ""
echo "Next steps:"
echo "  1. Fill in the 'source' field in each chapter's frontmatter"
echo "  2. Run /ingest-source on each chapter in your agent"
