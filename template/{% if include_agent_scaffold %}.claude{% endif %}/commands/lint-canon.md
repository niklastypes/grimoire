---
name: lint-canon
description: Check vault health by validating property completeness and canon consistency across all entity notes in world/.
---

# Lint Canon

You are running a quality check on a Grimoire worldbuilding vault. Your job is to validate every entity note in `world/` against the property schema and canon rules, then report issues.

## Process

### Step 1: Gather all entity notes

Read every `.md` file in `world/`. For each note, parse the frontmatter and identify its `type`.

Skip files that are not entity notes (no `type` property, or `type` is not one of the recognized entity types).

### Step 2: Validate property completeness

For each entity note, check that all **required base properties** are present and non-empty:

| Property | Required on | Valid values |
|----------|------------|--------------|
| `type` | all entities | `character`, `location`, `item`, `faction`, `lore`, `scene` |
| `status` | all entities | `draft`, `ready`, `revealed`, `retired` |
| `canon` | all entities | `true`, `false` |
| `source` | all entities | any non-empty string (e.g., `"self"`, `"Author 2024"`) |
| `genai` | all entities | `true`, `false` |
| `tags` | all entities | list (may be empty) |

Then check **type-specific required properties**:

| Type | Additional required properties |
|------|-------------------------------|
| `character` | `character-type` (must be `pc` or `npc`) |
| `faction` | (none beyond base) |
| `item` | (none beyond base) |
| `location` | (none beyond base) |
| `lore` | `category` (must be one of: `technology`, `history`, `culture`, `geography`, `politics`, `religion`, `science`, `event`) |
| `scene` | `location` (should be a wikilink), `characters` (should be a non-empty list) |

**Issue classifications:**
- `missing`: property key does not exist in frontmatter
- `empty`: property key exists but has no value
- `invalid`: property has a value not in the allowed set

Empty optional properties (like `faction` on a character or `district` on a location) are not errors. Only flag required properties.

### Step 3: Validate canon consistency

Check for logical inconsistencies in how canon properties are used:

1. **Non-canonical entities linked from canonical ones**: if a note with `canon: false` is wikilinked from the body of a note with `canon: true`, flag it. Canon should not depend on non-canon.

2. **Clue without secret**: if `clue: true` but `links-to-secret` is empty, the clue points nowhere.

3. **GenAI provenance**: if `genai: true` and `source` points to a human-written source, flag for review. Convention: `genai: false` for entities extracted from human-written sources, even though an agent did the extraction.

4. **Status lifecycle**: `revealed` or `retired` entities should have `canon: true`. Non-canonical content doesn't get revealed to players.

### Step 4: Check wikilink health

For each wikilink found in entity notes (both frontmatter and body):
- Does the target note exist in `world/`?
- If not, does it exist elsewhere in the vault?
- Flag broken links (target does not exist anywhere)

### Step 5: Check for orphan entities

For each entity in `world/`, check if **any other note in the vault** links to it (wikilink in body or frontmatter). An entity is an orphan if:
- No other entity in `world/` links to it
- No scene, session, or other note anywhere in the vault links to it

Orphans aren't necessarily errors (a freshly ingested entity may not be linked yet), so report them as **info**. But a high orphan count suggests the entity graph is disconnected and needs linking work.

### Step 6: Report

```
## Lint Canon Report

**Scanned:** N entity notes in world/
**Issues:** N errors, N warnings, N info

### Errors (must fix)
Issues that indicate broken or invalid data.

- **[[entity-name]]** (type)
  - `property`: missing required property
  - `character-type`: invalid value "warrior" (expected: pc, npc)

### Warnings (should review)
Issues that indicate potential problems.

- **[[entity-name]]** (type)
  - Non-canonical entity linked from canonical [[other-entity]]
  - `clue: true` but `links-to-secret` is empty

### Info

- N entities still in `draft` status
- N entities with `genai: true`
- Source coverage: N unique sources referenced
- Broken wikilinks: [[target-1]], [[target-2]] (or "none")
- Orphan entities (no incoming links): [[orphan-1]], [[orphan-2]] (or "none")

### Summary

| Type | Count | Errors | Warnings |
|------|-------|--------|----------|
| character | N | N | N |
| location | N | N | N |
| item | N | N | N |
| faction | N | N | N |
| lore | N | N | N |
| scene | N | N | N |
| **Total** | **N** | **N** | **N** |
```

## Rules

- Read every `.md` file in `world/`. Do not skip files.
- Read the grimoire-overlay skill for the canonical property schema.
- Be thorough but not pedantic. Empty optional properties are not errors.
- Report issues with specific note names and property names so the user can fix them directly.
- Do not modify any files. This command is read-only.
- If the vault has zero entity notes, report that and exit.
