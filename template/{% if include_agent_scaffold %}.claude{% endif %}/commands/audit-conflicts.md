---
name: audit-conflicts
description: Surface contradictions, duplicates, and relationship mismatches across canon entries in world/.
---

# Audit Conflicts

You are auditing a Grimoire worldbuilding vault for contradictions and inconsistencies across entity notes. Unlike `lint-canon` (which checks individual notes against the schema), this command checks **relationships between notes** for logical conflicts.

## Process

### Step 1: Build the entity graph

Read every `.md` file in `world/`. For each entity, extract:
- All frontmatter properties
- All `[[wikilinks]]` in the body (these represent narrative relationships)
- All wikilinks in frontmatter values (e.g., `faction: "[[the-chromeria]]"`)

Build a mental model of which entities reference which others.

### Step 2: Check for contradictions

#### Property cross-reference conflicts

When two entities reference each other, their properties should be consistent:

- **Faction membership**: if `character-A` has `faction: "[[faction-X]]"`, then `faction-X`'s Members section should mention `character-A`. Flag one-sided references.
- **Location containment**: if `location-A` has `parent-location: "[[location-B]]"`, then `location-B` should mention `location-A` in its body or connections. Flag one-sided references.
- **Item ownership**: if `item-A` has `held-by: "[[character-B]]"`, then `character-B` should mention `item-A` somewhere. Flag one-sided references.
- **Character alive status**: if `character-A` has `alive: false` but another entity's body text describes them as present or active (without past tense), flag it.

#### Source attribution conflicts

- **Same entity, conflicting facts across sources**: if an entity has been updated from multiple sources (check `source` property and body text attributions), look for contradictory statements. Example: Source A says a character is from City X, Source B says City Y. Flag with both source attributions so the user can adjudicate.
- **Same-source contradictions**: contradictions within a single source are likely typos or errors in the source itself. Flag these separately with lower confidence.

#### Temporal conflicts

If `sources/_digest.md` exists, check entity properties against the established timeline:
- Events described as happening "before" another event should have consistent entity states
- Characters present at events should have `alive: true` at that point in the timeline

If no digest exists, skip this check.

### Step 3: Check for duplicates

Look for entities that may represent the same thing:

- **Name similarity**: filenames that are very similar (e.g., `the-ghostrunner.md` and `ghostrunner.md`, or `berlin-mitte.md` and `mitte.md`)
- **Alias overlap**: if two entity notes mention the same alternate name in their body
- **Content overlap**: two entities of the same type with substantially similar descriptions

For each potential duplicate, report both notes and explain why they might be the same entity.

### Step 4: Check relationship completeness

- **Factions without members**: faction notes where no character lists that faction in their `faction` property
- **Locations without connections**: location notes not referenced by any character, item, or scene
- **Scenes with missing actors**: scene notes listing characters in `characters` property where those character notes don't exist
- **Items without holders**: item notes where `held-by` is empty and no entity mentions the item

These aren't necessarily errors (a newly created faction may not have members yet), so report them as **info**, not warnings.

### Step 5: Report

```
## Conflict Audit Report

**Scanned:** N entity notes in world/
**Findings:** N contradictions, N potential duplicates, N relationship gaps

### Contradictions (requires adjudication)
Conflicting information across entities or sources. The user must decide which is correct.

#### [[entity-name]]: conflicting faction membership
- **[[character-a]]** claims faction: [[faction-x]]
- **[[faction-x]]** Members section does not list [[character-a]]
- **Sources:** "Author Ch.3" vs "Author Ch.7"
- **Suggestion:** add [[character-a]] to [[faction-x]] Members, or correct the character's faction property

### Potential Duplicates
Entities that may represent the same thing.

- **[[the-ghostrunner]]** and **[[ghostrunner]]** (character)
  - Both describe a masked figure operating in [[berlin-mitte]]
  - **Suggestion:** merge into one note, add the other name as an alias

### Relationship Gaps (info)
Missing backlinks or isolated entities. Not necessarily wrong, but worth reviewing.

- **[[faction-x]]**: no characters list this as their faction
- **[[ancient-sword]]**: `held-by` is empty, not mentioned by any character
- **[[abandoned-outpost]]**: not referenced by any scene or character

### Summary

| Check | Findings |
|-------|----------|
| Property cross-reference conflicts | N |
| Source attribution conflicts | N |
| Temporal conflicts | N |
| Potential duplicates | N |
| Relationship gaps | N |
```

## Rules

- Read every `.md` file in `world/` and optionally `sources/_digest.md`. Do not skip files.
- Read the grimoire-overlay skill for the canonical property schema.
- Contradictions require the user to decide what's correct. Never auto-resolve them.
- Report with specific entity names, property names, and source attributions so the user can fix issues directly.
- Distinguish confidence levels: definite conflict vs possible duplicate vs informational gap.
- Do not modify any files. This command is read-only.
- If the vault has zero entity notes, report that and exit.
