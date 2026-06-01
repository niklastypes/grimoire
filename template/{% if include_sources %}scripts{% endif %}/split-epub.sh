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

# --- Unzip epub and find chapter files ---

echo "Extracting $(basename "$EPUB_FILE")..."
unzip -o "$EPUB_FILE" -d "$TEMP_DIR" > /dev/null 2>&1

# Find XHTML/HTML files, filter to likely chapters (skip toc, cover, nav, etc.)
CHAPTER_FILES=()
while IFS= read -r f; do
  basename_lower=$(basename "$f" | tr '[:upper:]' '[:lower:]')
  # Skip obvious non-chapter files
  if [[ "$basename_lower" =~ ^(toc|nav|cover|title|colophon|copyright|imprint|index)\. ]]; then
    continue
  fi
  CHAPTER_FILES+=("$f")
done < <(find "$TEMP_DIR" -name "*.xhtml" -o -name "*.html" | sort)

if [[ ${#CHAPTER_FILES[@]} -eq 0 ]]; then
  echo "Error: no XHTML/HTML files found in the epub."
  exit 1
fi

echo "Found ${#CHAPTER_FILES[@]} files. Converting to markdown..."

# --- Convert each chapter ---

CHAPTER_NUM=0
for f in "${CHAPTER_FILES[@]}"; do
  # Convert to clean markdown: gfm format, strip residual HTML tags
  CONTENT=$(pandoc "$f" -f html -t gfm --wrap=none --strip-comments 2>/dev/null \
    | sed 's/<[^>]*>//g' \
    | sed '/^[[:space:]]*$/N;/^\n[[:space:]]*$/d')

  # Skip files with very little content (likely metadata/frontmatter pages)
  WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')
  if [[ "$WORD_COUNT" -lt 50 ]]; then
    continue
  fi

  CHAPTER_NUM=$((CHAPTER_NUM + 1))
  PADDED=$(printf '%02d' "$CHAPTER_NUM")
  OUTPUT_FILE="$SOURCES_DIR/chapter-${PADDED}.md"

  {
    echo "---"
    echo "type: source"
    echo "source: \"\""
    echo "date-ingested: $(date +%Y-%m-%d)"
    echo "---"
    echo ""
    echo "$CONTENT"
  } > "$OUTPUT_FILE"

  echo "  chapter-${PADDED}.md ($WORD_COUNT words)"
done

# --- Report ---

if [[ $CHAPTER_NUM -eq 0 ]]; then
  echo ""
  echo "Error: no chapters with substantial content found."
  echo "The epub may use an unusual structure."
  exit 1
fi

echo ""
echo "Done. $CHAPTER_NUM chapters written to $SOURCES_DIR/"
echo ""
echo "Next steps:"
echo "  1. Fill in the 'source' field in each chapter's frontmatter"
echo "  2. Run /ingest-source on each chapter in your agent"
