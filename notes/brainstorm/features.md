# Brainstorm: Features

> Features mapped by layer. v1 focuses on Layer 1 (canon) and Layer 2 (creative); Layer 3 features (TTRPG play) are conditional on `project_type`. Some features (audio zones, fog of war, AI agent workflow) are deferred to post-v1.

## Layer 1: Canon

### Entity Graph

- Universal entity types: character, location, item, faction, lore
- `lore` carries a `category` property covering `technology | history | culture | geography | politics | religion | science | event`
- The `event` category captures what HAPPENED in canonical timeline (events from source material, key moments in the world's history)
- Properties + Bases queries handle navigation; no folder hierarchy inside `world/`

### Canon vs Invention

- Every entity carries `canon: true | false` (default `true`)
- Distinguishes source-derived content from user inventions
- Downstream consumers (Remembrance, future AI agents) filter on this
- `source: ""` attribution sits alongside (e.g., `"Hillenbrand 2018"`, `"Lightbringer Wiki"`, `"self"`)

### Source Material

- `sources/` (conditional on `include_sources`) for raw source material from adapted projects
- Chapter-by-chapter notes from novels
- Captured fandom wiki extracts
- Curated timeline of source events
- No enforced structure inside `sources/` — user organizes per source

### Source Summaries (running story digest)

Source chapters get long. Once entities have been extracted via `ingest-source`, the raw chapter shouldn't need to be re-read by downstream skills (`compose-scene`, vault gardener, etc.) or by Claude on later runs. We need a layered summary:

1. **Per-source-note summary**, written into the source note itself by `ingest-source`. Compact (≤ ~200 words for a novel chapter): what happens, who appears, what changes, where it leaves off. Lives directly above or below the raw text in the source note. Generated at ingest time so the agent doesn't re-derive it later.
2. **Running story digest**, one file per project (`sources/_digest.md` or similar). Updated additively at each ingest. Chronological, chapter-by-chapter one-liners plus an "as of source X" cumulative arc summary. The single artifact later skills load instead of the full source corpus.

**Why:**
- Layer-2 work (scene composition, session prep) needs story shape, not paragraph detail.
- Re-reading 5,000-word chapters into context for every operation is slow and expensive.
- A human GM rereading the vault three months later wants the digest, not the raw text.

**Status:** v1 deliverable as part of `ingest-source` v2 (current `ingest-source` only extracts entities). Validate on Hologrammatica Ch. 1–5+ once chapters accumulate.

See [scene-composition.md](scene-composition.md) for the Layer 2 consumer of this digest.

## Layer 2: Creative

### Narrative Work (`story/`)

- Plot arcs, scenes, character arcs specific to your project
- Universal across media: TTRPG campaign plot, novel chapter outlines, video game quest design, screenplay beat sheet
- `scene.md` template carries this work; for TTRPG it's literal scenes, for video game it can be quest-narrative work, for novel it's chapter outlines

### Scene & Session Composition (skills)

Layer-2 sibling to Layer-1's `ingest-source`. Two skills:

- **`compose-scene`** — turns canon (+ optional source slice, + optional user brief) into a table-ready scene note in `story/`. Two modes: adaptation (source-driven) and original (brainstorm-with-user). Always produces a vivid read-aloud Intro paragraph, a compact beat table, a per-NPC voice cheat with sample phrases, "what's off" friction handles, a refusal branch, hooks-out, and a GM-only worldbuilding-pflichtbeats checklist. Optionally emits a `.canvas` visualization and one or more in-world handouts in `play/`.
- **`compose-session`** — bundles 2–5 scenes into a pacing-aware session, surfaces prep needs, produces a `session-prep` note.

Design constraints captured separately because they're substantial — see [scene-composition.md](scene-composition.md). Key rule: bias toward at-a-glance GM cards (tables, quoted phrases, bullets) over prose. Validated empirically on Hologrammatica Ch. 1 → Szene 01.

### Systems Work (`mechanics/`)

- Conditional folder, present when `project_type in [ttrpg, video-game]`
- TTRPG: house rules, ruleset reference (HTBAH at Earliest Usable), session-running rules
- Video game: gameplay mechanics, combat system specs, progression design, drafting/magic mechanics, level design philosophy
- Board game (future): the core gameplay, rules, components
- No template ships for mechanics in v1 — free-form, users populate per project shape

### Decision Trees and Branching

- At important crossroads, document options and consequences
- "What happens if they don't" tracks: consequences when players/audience ignore a thread
- Branching points captured in `scene.md` template

### Timeline / Chronology

- World events independent of audience knowledge: in Layer 1 lore (`category: event`)
- Project timeline: when scenes happen in our adaptation, in Layer 2 story
- Optional Timeline plugin integration (Earliest Lovable)

## Layer 3: Production (TTRPG-specific in v1)

### Session Management

- `play/` folder with session-prep, session-log, encounter notes
- GM screen dashboard: start page per session with active characters, quick links, soundboard, contingency notes
- Session prep notes: what needs preparation for this session
- Session log: what happened, open threads, next session prep
- Player feedback note: what went well, what didn't
- Session pacing tracker

### Encounter System

- Three templates: combat, social, exploration
- Encounters carry `session: <n>` property linking them to their session
- Checklists: what needs prepping (characters, map, loot, difficulty, possible outcomes)
- Initiative tracker (community plugin integration at Earliest Lovable)

### Audio & Immersion (TTRPG)

- Soundboards per scene/location: ambient loops, background music, one-shot sounds
- Audio embedded in notes: playable on click via community plugin
- Plugin candidates: TTRPG Tools: Soundboard, RPG Audio (see [research.md](research.md))
- **Audio zones** (dream feature, deferred): audio on maps with proximity/filtering — likely outside Obsidian scope, FoundryVTT territory

### Maps & Visuals (TTRPG)

- Maps on second screen: world maps, floor plans, location illustrations
- Mood boards / atmosphere images per scene
- **Fog of War** (deferred): incremental map reveal via Leaflet plugin or similar — not v1
- Plugin: Leaflet via Javalent's TTRPG stack

### Initiative Tracker (TTRPG)

- Combat turn order tracking via community plugin
- Stat tracking (HP, AC, conditions) during encounters
- Integration with Fantasy Statblocks (Javalent stack)

## Cross-Layer Features

### GenAI Provenance

When AI tools generate an asset (a portrait, a piece of lore text, a voice clip), the source note records this:

- Frontmatter flag: `genai: true` on the parent note
- Body section: `## Generated Assets` table with `Asset | Prompt | Model | Date`

**Why:** transparency (which content is human vs AI), re-generation (regenerate the same portrait at higher quality with the same prompt), refinement (tweak and re-run), authorship traceability. Specifically valuable when a project runs over months and a year later you want to recreate or extend an existing asset.

Applies to: characters (portraits, voice samples), locations (images, maps), items (images), lore (illustrative images), factions (logos), any non-text asset, and AI-generated body text where worth tracking.

### Style Guide

`style-guide.md` (Earliest Usable, auto-populated from `genre` + `genre_theme`):

- Color palette
- Typography (headers, body, documents)
- Image generation prompt presets per entity type (character portrait, location, item)
- Negative prompts
- Audio style (music, ambient, SFX)
- Handout design (TTRPG)

The style guide is the GenAI prompt-engineering source-of-truth for the project. All assets follow these guidelines for consistency.

### Spoiler / Audience Management

Two mechanisms (the previously-considered "session-prep spoiler watch" section was dropped in v1):

1. **`status` property** (`ready` → audience hasn't seen, `revealed` → audience knows): queryable in Bases
2. **Callout layers**: `[!warning]` for creator-only secrets, `[!tip]` for audience-safe knowledge

Universal across media: TTRPG GM secrets, novel plot reveals, screenplay setups vs payoffs, video game spoiler-sensitive design decisions.

### End-of-Project Workflow

Projects end. What happens to the vault?

#### v1 (Earliest Lovable): Frozen-State Pattern

When a project wraps:

1. Set `status: completed` on `home.md`
2. Fill in `ended:` date
3. Git-tag the repo (e.g. `v1.0-finale`)
4. Stop editing

No tooling enforcement. The status flag makes the project discoverable as "done" across multiple project vaults via Bases queries. The Git tag preserves a stable reference point.

#### Future: Audience-Safe Export

Walks the vault, filters by `canon: true` AND `status: revealed`, strips `[!warning]` callouts, produces an audience-facing site:

- **TTRPG players** browse the live player wiki between sessions; updates appear as the GM updates the vault
- **Novel readers**: the book itself is the artifact; not applicable to vault export
- **Video game audiences**: the game is the artifact; not applicable

**Implementation candidate:** [Quartz](https://quartz.jzhao.xyz/) (static-site generator built specifically for Obsidian vaults) instead of a custom Python export script. See [integrations.md](integrations.md#implementation-candidate-quartz-instead-of-a-custom-python-export-script) for the trade-off comparison and recommended deployment shape (self-hosted on Qube, per-vault config).

Deferred. Meaningful as a follow-on milestone for TTRPG-focused projects.

#### Future: Chronicle / Lore Audio Compilation

When Remembrance matures: generate an audio "campaign chronicle" or "novel companion" from the vault content plus (if TTRPG) Clairvoyance session artifacts. The artifact-as-podcast / artifact-as-audiobook. Very deferred.

### Vault Gardener (Future)

The vault health scripts described in [infrastructure.md](infrastructure.md) (orphan check, canon consistency, property completeness, template drift) are designed as on-demand / CI-triggered checks. A natural evolution: run them on a schedule, with LLM-assisted analysis on top.

**The pattern** (separately validated for Mikoshi, cross-applies cleanly to Grimoire-generated vaults):

- **Nightly cron** runs against the vault while the creator sleeps. Inspired by the brain's overnight glymphatic clearance + memory consolidation; backed by the "sleep-time compute" architectural pattern ([Letta AI 2025](https://arxiv.org/abs/2504.13171)) — heavy reasoning runs off-peak, daytime queries are fast because precomputed structure is in place.
- **Four phases per run:**
  1. **Hygiene** (deterministic, auto-applied, git-committed under a dedicated author): broken-link repair, lint formatting, frontmatter-schema fixes, dead-attachment cleanup. Extends the existing pre-commit checks and vault health scripts.
  2. **Decay tracking** (surfaced, not applied): stale notes, stale `last_reviewed`, dangling plot threads, NPCs introduced N sessions ago without follow-up
  3. **Connection enrichment** (LLM-assisted, surfaced): missing backlinks via semantic similarity, "NPC A and NPC B share two faction memberships, consider an interaction scene"
  4. **Insight surfacing** (LLM-assisted, surfaced) — creative-vault-specific signals to look for:
     - **Orphan canon**: Layer 1 entities (characters, locations, items, factions) with `canon: true` that are never linked from Layer 2 (`story/`, `mechanics/`) or Layer 3 (`play/`). "You defined 12 noble houses but only 2 appear in plot beats — three more would round out the politics."
     - **Unused source coverage**: locations / events / characters in `sources/` that have not been adapted to `world/` or pulled into `story/`. "Chapter 14 of Hillenbrand has a hologram-runaway subplot you haven't surfaced in your campaign yet."
     - **Faction depth without plot weight**: factions with many canon entities but no `story/` arc using them. "Faction X has 8 members and 3 sub-orgs; none drive an arc."
     - **Loose threads in play**: NPCs introduced in a session-log but never reappearing, clues placed but never resolved, foreshadowing without payoff
     - **Mechanics drafted but unused**: rules in `mechanics/` never referenced from a scene or session — either retire them or surface a scene where they shine
     - **Tight semantic clusters → MOC promotion**: groups of entities with high cross-link density that lack a containing concept-page (e.g. "you have 7 notes orbiting 'the smuggling network' but no entry for it as a faction")
     - **Growth and quiet zones**: which subdirectories accreted the most this week vs which haven't been touched in 30+ days
- **Output:** a single markdown briefing note dropped into the vault (for TTRPG vaults: useful as session-prep digest between sessions). Auto-applied changes are git-committed with conventional messages, all surfaced changes link to one-click actions.
- **Safety contract:** no deletions (archive moves only), all non-deterministic changes surfaced not applied, panic-button via `git revert` on the gardener author's commits.

**Cadence:** nightly for hygiene + decay + connection; weekly for deep insight; monthly for graph-clustering audits.

**Why it matters for TTRPG vaults specifically:** the session-prep digest is genuinely useful between sessions. The GM wakes up to "here's what's tidy, here's what's unresolved, here's what plot threads need attention this week" rather than auditing the vault by hand before each session.

**Status:** out of v1 scope; the vault health scripts are the v1 deliverable. Document the Gardener pattern here so the v1 scripts are designed in a way that composes into it later (same checks, runnable on schedule, output-as-briefing-note shape).

## Random Tables

- Character names, encounters, loot, atmosphere details (TTRPG-flavored, useful for any worldbuilding)
- On-the-fly generation via dice plugin or Templater button when the audience does something unexpected
- Custom random table notes can live anywhere in the vault; convention is `world/tables-*.md` or `mechanics/tables-*.md`

## World Building

### Relationship Web / Faction Map

- Visual representation via Canvas or Graph View (Obsidian core)
- Useful for both TTRPG factions and video game quest dependencies

### Character / NPC Library

- Generic character pool (innkeeper, guard, merchant) as a starter set, genre-dependent
- Useful for both TTRPG quick-NPCs and video game NPC populations
- Can be stored in `world/` as `canon: false` characters (treated as filler unless specifically established as canon)

### Secrets & Clues Tracking

- Which secrets exist, which clues lead to them, which have been revealed
- `clue: true` property + `links-to-secret` + `found-at` on any entity
- Bases view "all clues" and "unrevealed clues"
