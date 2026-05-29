# Brainstorm: TTRPG Ruleset Addendum

> TTRPG-specific addendum. Only relevant when `project_type == 'ttrpg'`. Covers HTBAH mechanics, character system, property strategy, and ruleset progression. The reference content here ships in the generated vault's `mechanics/` folder at Earliest Usable when `ruleset=htbah`.

For video-game and generic project types, mechanics/ is free-form and unrelated to TTRPG rulesets.

## Ruleset: How to be a Hero (HTBAH)

> [!tip]
> HTBAH is intentionally lightweight and setting-agnostic. Skills are freely definable, making it ideal as a TTRPG default that gets adapted per campaign. German PnP ruleset from howtobeahero.de.

### Core Mechanics

- **3 Begabungen (aptitudes)**: Handeln (physical), Wissen (knowledge), Soziales (social)
- **Fähigkeiten (skills)**: freely chosen, assigned to an aptitude, 400 points to distribute
- **Begabungswert (aptitude value)**: sum of assigned skill points / 10 (added as bonus to all skills in that aptitude)
- **Geistesblitzpunkte (flash of insight points)**: aptitude value / 10, allow rerolls (bound per aptitude, regenerate per adventure/evening)
- **Hit points**: 100, unconscious below 10 or on 60+ damage in one hit, death at 0
- **Vor-/Nachteile (advantages/disadvantages)**: character traits, cost/grant skill points
- **Skill checks**: d100 against skill value, critical success in lower 10%, critical failure in upper 10%
- **Combat**: initiative (1d10 + Handeln), turn-based, attack against skill, 1 parry per round against Handeln
- **Damage**: d10-based per weapon type (1d10 fist to 10d10 explosive), critical hit doubles damage

### Where this lives in a TTRPG vault

For `project_type: ttrpg` with `ruleset: htbah`:

- `mechanics/htbah-core.md` — core mechanics reference (Begabungen, skill checks, combat)
- `mechanics/htbah-skills.md` — common skill list with defaults
- `mechanics/htbah-weapons.md` — weapon table reference
- `mechanics/house-rules.md` — empty starter, GM fills in any house rules

These ship at Earliest Usable. Bilingual content (German+English) is fine; the project content language convention says project content can be in any language.

### Template Implications

- Character template must support freely definable skills
- Weapon table as reference, adjustable per setting
- No spell slot tracking or complex class features needed

## Character System (TTRPG)

> [!tip]
> PCs and NPCs share a single `character.md` template. The `character-type` property (`pc | npc | mc`) differentiates. Only truly dynamic, frequently-changing data lives in properties. Everything else stays in the note body.

### Unified Character Template

PCs and NPCs differ only in:

- `player` property (PC only)
- "How to Play / Voice" section (NPC only, delete for PCs)

Everything else is shared: appearance, personality, goals, secrets, stats, inventory, relationships, session notes.

### Property Strategy: Keep Frontmatter Lean

**Fixed properties (always present, ruleset-agnostic):**

```yaml
---
type: character
character-type: pc | npc | mc
status: active | draft | ready | revealed | retired
canon: true
source: ""
player: ""              # PC only
location: ""
alive: true
faction: ""
role: ""                # NPC: antagonist / ally / neutral / contact
clue: false
links-to-secret: ""
found-at: ""
tags: []
genai: false
---
```

**Dynamic stats (ruleset-dependent, ship per ruleset choice):**

HTBAH:

```yaml
hp: 100
```

D&D 5e (future preset):

```yaml
hp: 52
hp-max: 52
temp-hp: 0
spell-slots-1: 4
spell-slots-2: 2
```

Custom rulesets leave this block empty for the GM to define.

**Everything else in the note body**: Begabungswerte, Fähigkeiten, Vor-/Nachteile, GBP, combat stats. Set once during character creation, rarely changes, look up in the note when needed.

### Inventory

Not a manual list. Items with `held-by: [[character-name]]` are automatically shown via Bases view embedded in the character note. Works for both PCs (what they carry) and NPCs (what can be looted/stolen).

### Progression (Optional, Ruleset-Dependent)

**Stat-based (D&D, extended HTBAH):**

```yaml
# optional dynamic stats
exp: 0
level: 1
```

With a history table in the body:

| Session | EXP Gained | Reason | Spent On |
|---------|-----------|--------|----------|
| 5       | 150       | defeated the goblins | +10 Schwertkampf |

**Narrative (Hologrammatica, noir-style):**

No EXP stats, instead story-based progression tracked in the body:

- unlocked contact: [[detective-zhao]]
- acquired: [[neural-decrypt-module]]
- learned: the truth about [[project-genesis]]

Both optional, both configurable via Copier setup. Campaigns without progression simply omit the section.

## D&D 5e Compatibility (Future Preset, not v1)

- ~80% of the vault is ruleset-agnostic (story, NPCs, locations, assets, session management) and works directly with D&D
- ~20% would need adaptation: character sheets (class, level, spell slots, class features), encounter templates (CR, encounter balancing), combat tracker (conditions, bonus actions)
- **Approach**: keep `mechanics/` cleanly swappable; D&D 5e as a later Copier preset (`ruleset: dnd5e`)
- **Not part of v1**, but architect so it's retrofittable

## Custom Mechanics (Non-TTRPG project_types)

For `project_type: video-game` or `generic`, `mechanics/` is free-form. Examples:

- **Prisma** (video game, Lightbringer ARPG): drafting mechanics, combat system, progression design, level/encounter design philosophy. No specific template ships in v1; users populate as makes sense.
- **Board game** (future): game flow, components, win conditions, scenarios.
- **Novel** (future): mostly mechanics-free; some novels might define narrative-mechanical rules (e.g. Brandon Sanderson's hard magic systems) that benefit from documentation in mechanics/.

The point: ruleset is a TTRPG concept. Other media call this "game design," "system design," "magic system documentation," etc. Same folder (`mechanics/`), different content.
