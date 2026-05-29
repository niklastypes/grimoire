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

## Property Schema

All entity notes share these base properties:

| Property | Type | Default | Purpose |
|---|---|---|---|
| `type` | string | (per template) | Entity type: `character`, `location`, `item`, `faction`, `lore`, `scene` |
| `status` | string | `draft` | Lifecycle: `draft` → `ready` → `revealed` → `retired` |
| `canon` | boolean | `true` | Is this canonical to the universe? |
| `source` | string | `""` | Attribution: `"self"`, `"Hillenbrand 2018"`, `"Lightbringer Wiki"` |
| `tags` | list | `[]` | Freeform tags |
| `genai` | boolean | `false` | Was this content AI-generated? |

Type-specific properties are defined in each template's frontmatter. Always preserve the full schema when creating notes.

## Canon Rules

- **Default `canon: true`.** Everything you establish IS canon unless marked otherwise.
- **Mark `canon: false`** for non-canonical additions (filler NPCs, what-if scenarios, homebrew that contradicts source material).
- **Always set `source`** to a meaningful attribution string. Use `"self"` for original content.
- **Set `genai: false`** for human-written content, `true` for AI-generated content. The agent extracting entities from a human-written source sets `genai: false` (the source is human-written).

## Wikilink Conventions

- **Link entities to each other** using `[[entity-name]]` wikilinks
- **Use display names** when the link text differs from the filename: `[[kira-morgenrot|Kira]]`
- **Link in frontmatter** for structured relationships: `faction: "[[the-chromeria]]"`, `held-by: "[[kira-morgenrot]]"`
- **Link in body text** for narrative references: `Kira first encountered [[the-ghostrunner]] in [[berlin-mitte]]`

## Source Ingestion Workflow

When ingesting source material into the vault:

1. **Source note** goes in `sources/` with attribution metadata
2. **Entities extracted** go in `world/` using the appropriate template
3. **Check for existing entities** before creating new ones. Search `world/` by name and aliases
4. **Update existing entities** additively. Don't remove existing content, add new information
5. **Create wikilinks** between related entities discovered in the source
6. **Flag ambiguities** for the user rather than guessing

## Folder Reference

| Folder | What goes here |
|---|---|
| `world/` | All entities: characters, locations, items, factions, lore (flat) |
| `sources/` | Raw/cleaned source material with attribution |
| `story/` | Scenes, plot arcs, narrative structure |
| `mechanics/` | Game systems, rules, stat blocks |
| `play/` | Session prep, session logs, encounters (TTRPG only) |
| `templates/` | Note templates (do not place content here) |
| `views/` | Bases view definitions |
| `assets/` | Images, audio, media |
