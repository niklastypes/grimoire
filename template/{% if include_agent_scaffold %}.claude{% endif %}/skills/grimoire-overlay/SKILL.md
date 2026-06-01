---
name: grimoire-overlay
description: Grimoire worldbuilding conventions layered on top of Obsidian skills. Use when working with any Grimoire-generated vault, creating or editing entities, managing canon, or ingesting source material.
---

# Grimoire Overlay

Grimoire vaults use a three-layer model for creative worldbuilding. This skill teaches Grimoire-specific conventions on top of generic Obsidian knowledge.

## Three-Layer Model

| Layer | Purpose | Folders | Content |
|---|---|---|---|
| **1. Canon** | The universe as it IS | `world/` (always), `sources/` (when adapting) | Entities, lore, source material |
| **2. Creative** | What you BUILD on canon | `story/` (always), `mechanics/` (games) | Plot, scenes, game systems |
| **3. Production** | What you SHIP | `play/` (TTRPG only) | Sessions, encounters |

## Entity Creation Rules

- **Always use templates** from `templates/` when creating notes
- **Place all entities in `world/`** (flat, no subfolders). Navigation is via Bases views and wikilinks, not folder hierarchy
- **Filename convention:** lowercase kebab-case (e.g., `kira-morgenrot.md`, `the-chromeria.md`)
- **One entity per file.** If an entity has sub-aspects, link to separate notes
- **Content language:** write Layer 1 (canon) and Layer 2 (creative) content in the same language as the source material. Vault structure (folder names, property keys, template section headers) stays English.
- **H1 headline:** every entity note starts with `# Entity Name` (Title Case, matching the entity's display name) immediately after frontmatter. The agent must replace template placeholder names (e.g., "Character Name") with the actual entity name.
- **Infobox:** every entity has a `[!infobox]` callout right after the H1 headline with an image embed and a TL;DR summary (1-2 sentences). The image embed uses the full path `assets/images/<type>/<entity-name>.png` (e.g., `assets/images/characters/galahad-singh.png`, `assets/images/locations/camden.png`) (broken embed is fine if the image doesn't exist yet). The summary should capture the essence: who/what it is, why it matters. Do not repeat property values in the infobox.

## Property Schema

All entity notes share these base properties:

| Property | Type | Default | Purpose |
|---|---|---|---|
| `type` | string | (per template) | Entity type: `character`, `location`, `item`, `faction`, `lore`, `scene` |
| `status` | string | `draft` | Lifecycle: `draft` → `ready` → `revealed` → `retired` |
| `canon` | boolean | `true` | Is this canonical to the universe? |
| `source` | list | `[]` | Wikilinks to source notes: `["[[chapter-01]]", "[[chapter-03]]"]` |
| `tags` | list | `[]` | Freeform tags |

Type-specific properties are defined in each template's frontmatter. Always preserve the full schema when creating notes.

### Property Value Discipline

**Before assigning a value to any property, check what values already exist in the vault.** This prevents value sprawl that breaks Bases aggregation.

Specifically:
- **`source`**: list of wikilinks to source notes (e.g., `["[[chapter-01]]", "[[chapter-03]]"]`). Always point to actual files in `sources/`.
- **`faction`**: list of wikilinks to faction notes (e.g., `["[[the-chromeria]]"]`). If no faction note exists yet, create one first, then reference it.
- **`leader`**: list of wikilinks to character notes leading the faction.
- **`character-type`**: only `pc` or `npc`. No other values.
- **`category`** (lore): only `technology`, `history`, `culture`, `geography`, `politics`, `religion`, `science`, `event`. No other values.
- **`status`**: only `draft`, `ready`, `revealed`, `retired`. No other values.
- **`district`**, **`parent-location`**, **`held-by`**: always use `"[[wikilink]]"` format pointing to an existing note. If the target doesn't exist yet, create it first.
- **`location`** (scenes): list of wikilinks to location notes.
- **`tags`**: check existing tags in the vault before creating new ones. Reuse over invent.

**Rule of thumb:** if a property value would appear in a Bases "group by" or "filter by" query, it must be consistent across all notes. One wrong spelling breaks the group.

## Canon Rules

- **Default `canon: true`.** Everything you establish IS canon unless marked otherwise.
- **Mark `canon: false`** for non-canonical additions (filler NPCs, what-if scenarios, homebrew that contradicts source material).
- **Always set `source`** to wikilinks pointing to the source notes the entity was derived from. For original content, leave `source: []` empty (the absence of sources means it was invented by the user or agent).

## Wikilink Conventions

- **Link entities to each other** using `[[entity-name]]` wikilinks
- **Use display names** when the link text differs from the filename: `[[kira-morgenrot|Kira]]`
- **Link in frontmatter** for structured relationships: `faction: "[[the-chromeria]]"`, `held-by: "[[kira-morgenrot]]"`
- **Link in body text** for narrative references: `Kira first encountered [[the-ghostrunner]] in [[berlin-mitte]]`

## Source Ingestion Workflow

When ingesting source material into the vault:

1. **Raw source** goes in a named subdirectory of `sources/` (`chapters/`, `wiki/`, `fragments/`, etc.)
2. **Entities extracted** go in `world/` using the appropriate template
3. **Check for existing entities** before creating new ones. Search `world/` by name and aliases
4. **Update existing entities** additively. Don't remove existing content, add new information
5. **Per-source summary** goes in `sources/summaries/`, mirroring the raw source filename
6. **Running synthesis** (`sources/synthesis.md`) updated to reflect the new source's contribution
7. **Create wikilinks** between related entities discovered in the source
8. **Flag ambiguities** for the user rather than guessing

**Three-level navigation for source knowledge:**
- `sources/synthesis.md` - read first. Running world understanding.
- `sources/summaries/<source>.md` - drill into one source's contribution.
- `sources/<subdir>/<source>.md` - raw text for looking things up.

## Folder Reference

| Folder | What goes here |
|---|---|
| `world/` | All entities: characters, locations, items, factions, lore (flat) |
| `sources/` | Source material, summaries, and running synthesis |
| `sources/<subdir>/` | Raw sources organized by shape: `chapters/`, `wiki/`, `fragments/` |
| `sources/summaries/` | Per-source summaries (mirrors raw source filenames) |
| `sources/synthesis.md` | Running world understanding (always read first) |
| `story/` | Scenes, plot arcs, narrative structure |
| `mechanics/` | Game systems, rules, stat blocks |
| `play/` | Session prep, session logs, encounters (TTRPG only) |
| `templates/` | Note templates (do not place content here) |
| `views/` | Bases view definitions |
| `assets/` | Images, audio, media |
