---
name: ingest-source
description: Ingest source material into the vault. Handles novel chapters, wiki pages, and other reference material. Creates or updates entity notes in world/ and source notes in sources/.
---

# Ingest Source Material

You are ingesting source material into a Grimoire worldbuilding vault. Your job is to extract structured entities from the source and create or update notes in the vault.

## Input

The user will provide source material in one of these forms:
- **Pasted text**: a chapter excerpt, wiki page, or other reference material
- **File reference**: a path to a file already in `sources/` or elsewhere in the vault
- **URL**: a web page to extract (use the defuddle skill to get clean markdown)

Ask the user for:
1. The source material (or where to find it)
2. The attribution string (e.g., "Author, Book Title, Ch. 1", "Fandom Wiki - Topic")

## Process

### Step 1: Create or update source note

Save the raw or cleaned source material in `sources/`:
- Filename: lowercase kebab-case, descriptive (e.g., `source-book-ch01.md`, `wiki-magic-system.md`)
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

For wiki-style sources, the structure often maps directly to entity types. For narrative sources, extract entities from the prose.

### Step 3: Check for existing entities

Before creating any note, search `world/` for existing notes that might match:
- Search by filename (e.g., `world/kira-morgenrot.md`)
- Search by content (the entity name might appear in other notes)
- Consider aliases and alternate names

This step is critical for incremental ingestion. The same character may appear across multiple chapters or wiki pages.

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

### Step 5: Report

After processing, provide a summary:

```
## Ingest Summary

**Source:** <attribution>
**Source note:** sources/<filename>.md

### Created (N new entities)
- [[entity-name]] (type) — brief description
- ...

### Updated (N existing entities)
- [[entity-name]] — what was added
- ...

### Needs Review
- <any ambiguities, contradictions, or uncertain extractions>
```

## Rules

- All entities go in `world/` (flat, no subfolders)
- Filenames are lowercase kebab-case
- Always use the correct template's frontmatter schema
- Set `canon: true` for source-derived content
- Set `source` to the attribution string the user provided
- Set `genai: false` (the source material is human-written)
- Create `[[wikilinks]]` between related entities
- When updating existing entities, be additive (don't remove existing content)
- Flag ambiguities for the user rather than guessing
- Read the grimoire-overlay skill for full property schema and conventions
