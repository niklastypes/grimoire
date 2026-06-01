---
name: ingest-source
description: Ingest source material into the vault. Handles novel chapters, wiki pages, lore fragments, and other reference material. Creates or updates entity notes in world/, source notes in sources/, per-source summaries, and the running synthesis.
---

# Ingest Source Material

You are ingesting source material into a Grimoire worldbuilding vault. Your job is to extract structured entities from the source, create or update notes, write a summary of what the source contributed, and update the running world synthesis.

## Input

The user will provide source material in one of these forms:
- **Pasted text**: a chapter excerpt, wiki page, or other reference material
- **File reference**: a path to a file already in `sources/` or elsewhere in the vault
- **URL**: a web page to extract (use the defuddle skill to get clean markdown)

Ask the user for:
1. The source material (or where to find it)
2. The attribution string (e.g., "Author, Book Title, Ch. 1", "Fandom Wiki - Topic")

## Source Directory Structure

Sources are organized by shape. On the **first ingest**, ask the user what kind of source material they're working with (if not obvious), and create the appropriate subdirectory:

```
sources/
├── synthesis.md               # running world understanding (entry point)
├── chapters/                  # for novels, screenplays, linear narrative
│   ├── chapter-01.md
│   └── chapter-02.md
└── summaries/                 # mirrors raw source structure
    ├── chapter-01.md
    └── chapter-02.md
```

The raw source directory name adapts to the source shape:
- `chapters/` for novels, screenplays, linear narrative
- `wiki/` for reference material, fandom wiki extracts
- `fragments/` for pieced-together lore (item descriptions, NPC dialogue, environmental clues)

If the vault already has sources, follow the existing directory naming. Multiple source directories can coexist (e.g., `chapters/` and `wiki/` for a project that uses both novel text and fandom reference).

`summaries/` always mirrors the raw source directories. `synthesis.md` always sits at the top level of `sources/`.

## Process

### Step 1: Save the raw source

Save the raw or cleaned source material in the appropriate subdirectory of `sources/`:
- Filename: lowercase kebab-case, descriptive (e.g., `chapter-01.md`, `magic-system.md`, `sword-of-the-sun.md`)
- Frontmatter:

```yaml
---
type: source
source: "<attribution string>"
date-ingested: <today's date>
---
```

- Body: the source text (cleaned if from URL, verbatim if pasted)

### Step 2: Identify entities

Scan the source material for:
- **Characters**: named individuals, referenced people
- **Locations**: named places, regions, buildings
- **Factions**: organizations, groups, governments, orders
- **Items**: named objects, artifacts, weapons, tools
- **Lore**: technologies, historical events, cultural practices, magic systems, scientific concepts

For wiki-style sources, the structure often maps directly to entity types. For narrative sources, extract entities from the prose. For fragmented lore, each fragment may contribute partial information to existing entities.

### Step 3: Check for existing entities

Before creating any note, search `world/` for existing notes that might match:
- Search by filename (e.g., `world/kira-morgenrot.md`)
- Search by content (the entity name might appear in other notes)
- Consider aliases and alternate names

This step is critical for incremental ingestion. The same character may appear across multiple chapters, wiki pages, or item descriptions.

### Step 4: Create or update entity notes

**For each new entity:**
1. Choose the correct template from `templates/` based on entity type
2. Create the note in `world/` with lowercase kebab-case filename
3. Fill in frontmatter properties:
   - `type`: matching the template
   - `status: draft`
   - `canon: true` (source-derived content is canonical)
   - `source: "<attribution string>"`
   - `genai: false` (human-written source, even though an agent extracts it)
   - Type-specific properties (faction, role, district, etc.) where inferable from source
4. Fill in body sections from the source material
5. Add `[[wikilinks]]` to related entities (other characters, locations, factions mentioned)
6. Keep the `[!warning]- GM Secrets` section for information that should be hidden from players
7. Keep the `[!tip]- Property Guide` section (users may still need it)

**For each existing entity:**
1. Read the existing note
2. Add new information from this source (be additive, do not remove existing content)
3. Add new wikilinks to entities discovered in this source
4. Update frontmatter properties if the source provides new information (e.g., `faction` was empty, now known)
5. If the source contradicts existing content, flag it for the user rather than overwriting

**Content language:** write entity content in the same language as the source material. Vault structure (property keys, section headers) stays English.

### Step 5: Write per-source summary

Create a summary note in `sources/summaries/` mirroring the raw source filename:

```yaml
---
type: source-summary
source: "<attribution string>"
summarizes: "[[<raw source note>]]"
date-ingested: <today's date>
---
```

The summary body should be compact (150-250 words) and capture:

**For narrative sources (chapters):**
- What happens in this chapter (plot beats, not full retelling)
- Which entities appear or are mentioned
- What changes (character development, reveals, status shifts)
- Where the story leaves off

**For wiki sources:**
- What topics this source covers
- Key facts and relationships established
- How this connects to other ingested sources

**For lore fragments:**
- What this fragment reveals or hints at
- Which entities it relates to
- What theories or connections it supports

### Step 6: Update the running synthesis

Read `sources/synthesis.md` (create it if it doesn't exist). Update it to reflect the new source's contribution.

**If creating for the first time:**

```yaml
---
type: synthesis
last-updated: <today's date>
sources-ingested: 1
---
```

**The synthesis body adapts to the source shape:**

**For narrative sources:** chronological story arc. Per-source one-liner, plus a cumulative "story so far" section that captures the narrative arc, key relationships, unresolved threads, and where things stand.

**For wiki sources:** knowledge map. Topics covered, key relationships between entities, areas with good coverage vs gaps, open questions.

**For fragmented lore:** pieced-together understanding. What we think is true (with confidence), connections between fragments, competing theories, explicit unknowns.

**For mixed sources:** combine approaches. Separate sections if needed.

**Update rules:**
- Be additive. Don't rewrite sections that haven't changed.
- Update `last-updated` and `sources-ingested` count.
- Keep the synthesis readable as a standalone document. Someone reading only this file should understand the world's current state.

### Step 7: Report

After processing, provide a summary:

```
## Ingest Summary

**Source:** <attribution>
**Raw source:** sources/<subdir>/<filename>.md
**Summary:** sources/summaries/<filename>.md
**Synthesis:** sources/synthesis.md (updated)

### Created (N new entities)
- [[entity-name]] (type) — brief description
- ...

### Updated (N existing entities)
- [[entity-name]] — what was added
- ...

### Needs Review
- <any ambiguities, contradictions, or uncertain extractions>
```

## Three-Level Navigation

The agent (and the user) can navigate source knowledge at three levels of detail:

1. **`sources/synthesis.md`** — read this first. Running understanding of the entire world as of the last ingestion.
2. **`sources/summaries/<source>.md`** — drill into one source. What did this specific chapter/article/fragment contribute?
3. **`sources/<subdir>/<source>.md`** — the raw text. Look something up when the summary isn't enough.

Downstream commands (`compose-scene`, `audit-conflicts`, etc.) should read `synthesis.md` first and only dive into summaries or raw sources when they need specific detail.

## Rules

- All entities go in `world/` (flat, no subfolders)
- Raw sources go in a named subdirectory of `sources/` (e.g., `chapters/`, `wiki/`, `fragments/`)
- Summaries go in `sources/summaries/`, mirroring raw source filenames
- `sources/synthesis.md` is always updated after every ingest
- Filenames are lowercase kebab-case
- Always use the correct template's frontmatter schema
- Set `canon: true` for source-derived content
- Set `source` to the attribution string the user provided
- Set `genai: false` (the source material is human-written)
- Write entity and summary content in the same language as the source material
- Create `[[wikilinks]]` between related entities
- When updating existing entities, be additive (don't remove existing content)
- Flag ambiguities for the user rather than guessing
- Read the grimoire-overlay skill for full property schema and conventions
