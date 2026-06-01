---
name: update-primer
description: Create or update the player-facing world primer from current canon. Spoiler-free, engaging, designed to get players excited about the world.
---

# Update World Primer

You are generating or updating the player-facing `world-primer.md` for a Grimoire TTRPG vault. This document is what players read before (and between) sessions. It must be **spoiler-free, engaging, and accurate** to the current state of revealed canon.

## Input Sources

Read these in order:

1. **`sources/synthesis.md`** - overall world understanding (if it exists)
2. **`world/` entities** - but ONLY those with `status: revealed` or `status: ready` AND `canon: true`. Never include `draft` or `retired` entities.
3. **Existing `world-primer.md`** - preserve any hand-written sections the user has added (Tone & Feel, content boundaries, etc.)

## What to Write

The primer has these sections. Rewrite or update each based on current canon:

### The World
A vivid, evocative 2-3 paragraph overview of the setting. This is the hook. Write it like the back cover of a novel: atmospheric, intriguing, makes the reader want to explore. Avoid dry exposition.

### Factions
Key groups the players should know about. For each faction:
- Name (as a `[[wikilink]]` if the faction note exists)
- One-line public description (what a commoner would know)
- Why a player character might care (ally, enemy, employer, mystery)

Only include factions with `canon: true` and `status: ready` or `status: revealed`. Skip factions the players haven't encountered yet.

### Key Locations
Major places the players know about or will visit soon. For each:
- Name (as a `[[wikilink]]`)
- One-line atmosphere description
- What's notable (without spoiling secrets)

Only include locations with `status: ready` or `status: revealed`.

### What Your Character Knows
Common knowledge in this world. Things every resident takes for granted. This grounds the players in the setting without info-dumping. Write as bullet points, conversational tone.

### Tone & Feel
Preserve the user's hand-written content here. If empty, suggest a tone based on the genre and source material, but mark it as a suggestion for the user to confirm.

### Source Material (adapted projects only)
If the project is adapted from existing sources, note the sources but reassure players they don't need to have read them. The primer covers what their character would know.

## Writing Guidelines

- **No spoilers.** Never reveal GM secrets, unrevealed clues, or `[!warning]` callout content. If in doubt, leave it out.
- **Be engaging, not encyclopedic.** This isn't a wiki dump. It's a sales pitch for the world. Use evocative language, hint at mysteries, create anticipation.
- **Write in the source material's language.** If the vault content is in German, the primer should be in German.
- **Keep it scannable.** Players skim. Use short paragraphs, bullet points, bold key names. Target 1-2 pages when printed.
- **Create hooks, not spoilers.** "The Undercity hums with secrets and forbidden trade" is a hook. "The Undercity is where the rebel faction hides their base" is a spoiler.
- **Update incrementally.** When updating an existing primer, add newly revealed content and refine existing sections. Don't rewrite from scratch unless the user asks.

## Process

1. Read the input sources listed above
2. Identify all entities eligible for the primer (`canon: true`, `status: ready` or `revealed`)
3. Check the existing `world-primer.md` for hand-written content to preserve
4. Write or update each section following the guidelines
5. Report what changed:

```
## Primer Update Summary

**Entities included:** N (of M total canon entities)
**Newly added:** [[entity-1]], [[entity-2]] (just reached "revealed" status)
**Sections updated:** The World, Factions, Key Locations
**Preserved:** Tone & Feel (hand-written), Source Material (unchanged)
**Excluded (not yet revealed):** N entities still in draft
```

## Rules

- Never include entities with `status: draft`. They're not ready for players.
- Never reveal `[!warning]` callout content from entity notes. That's GM-only.
- Never mention `clue`, `links-to-secret`, or any spoiler-management properties.
- Preserve hand-written sections the user has added (check for content that doesn't come from entity notes).
- If the vault has no revealed entities yet, write a placeholder primer based on `synthesis.md` and the genre, and note that it will be enriched as the world is revealed.
- Do not modify any files other than `world-primer.md`.
