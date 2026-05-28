# 📜 Grimoire — Brainstorm: Integrations & the Creative Loop

> The strategic positioning of Grimoire: a structured data substrate for an entire creative ecosystem. Multiple downstream consumers read different layers for different purposes.

## The Creative Loop

Grimoire's vault is the universal data layer. The full creative loop spans multiple projects in the galaxy:

```
Source material (book, fandom wiki, original imagination)
        │
        ▼
┌─────────────────────────────────────────────┐
│  GRIMOIRE VAULT                             │
│  Layer 1: canon (world/, sources/)          │ ◄── Remembrance: reads canon for
│                                              │     canon stories in the universe
│  Layer 2: creative (story/, mechanics/)     │ ◄── Remembrance: reads for stories
│                                              │     in OUR adaptation/campaign
│  Layer 3: production                         │
│   (play/ for TTRPG, or external)            │
└────────┬────────────────────────────────────┘
         │
         ▼ (live TTRPG sessions)
   ┌─────────────────────────────┐
   │  Clairvoyance               │ ◄── records the live sessions
   │  (sessions in the vault)    │
   └─────────────┬───────────────┘
                 │
                 ▼
   Clairvoyance artifacts (transcripts, summaries)
                 │
                 ▼
   ┌─────────────────────────────┐
   │  Remembrance                │ ◄── consumes vault layers 1+2 PLUS
   │                             │     Clairvoyance artifacts → generates
   │                             │     new stories set in OUR played campaign
   └─────────────────────────────┘
```

**Each layer naturally maps to a downstream consumer:**

- **Layer 1 (canon)** → Remembrance reads it to generate canonical lore stories in the universe
- **Layer 1+2 (canon + adaptation)** → Remembrance reads both to generate stories in *our* adaptation
- **Layer 1+2 + Clairvoyance artifacts** → Remembrance reads everything to generate stories from *what actually happened* at the table
- **All layers** → future Tavern (AI Dungeon Master) reads everything to run sessions autonomously

## Far-Future Autonomous Loop

The end state where the creative ecosystem closes the loop:

```
Tavern (AI Dungeon Master, future)
   │
   ├── reads Layer 1 (canon) from a Grimoire vault
   ├── builds Layer 2 (campaign) autonomously
   ├── runs Layer 3 (live session) autonomously
   │     │
   │     ├── Momo wears Corset, connects to Tavern as the DM voice
   │     │   (narration + character; Tavern handles game-loop mechanics)
   │     ├── Remembrance plays NPCs (voice + lore-grounded improv)
   │     └── Clairvoyance sits in, records everything
   │
   └── Post-session, Remembrance generates new stories from the played adventure
```

Source → canon → creative → played → captured → new stories. Each artifact feeds the next.

## Concrete Downstream Consumers

### Remembrance

Reads the Grimoire vault to generate audio content in the universe.

**Modes:**

- **Canon-only mode**: filters `canon: true` across `world/` and `sources/`. Generates lore audio that's strictly canonical (e.g., "the history of the Chromeria," "the discovery of Holograms"). Works regardless of whether you've built Layer 2 yet.
- **Adaptation mode**: reads `world/` + `sources/` + `story/` + `mechanics/`. Generates audio relevant to the user's specific adaptation (e.g., "side stories in our Hologrammatica campaign world").
- **Session-aware mode (future)**: reads everything plus Clairvoyance artifacts. Generates "stories from our played campaign" — narrating what happened at the table as in-universe lore.

For Niklas's case: he's a super-fan of Lightbringer, builds a perfect Layer 1 Lightbringer vault for Prisma. Remembrance reads it and starts generating canon Lightbringer stories he can consume. Then he layers a Prisma-specific story on top (Layer 2), and Remembrance shifts to generating stories in *that* version of the universe.

### Clairvoyance

Records live TTRPG sessions and produces structured artifacts (transcripts, timelines, speaker-labeled audio).

**Integration with Grimoire:**

- Clairvoyance doesn't directly modify the Grimoire vault. It produces standalone artifacts.
- Convention: Clairvoyance artifacts can be linked from `play/session-log.md` notes (the GM references the recording).
- Earliest integration: when Clairvoyance can export markdown transcripts, those can be embedded in or linked from session-log notes.

### Tavern (Far Future)

AI Dungeon Master that consumes a Grimoire vault and runs TTRPG sessions autonomously.

**Reads:**

- Layer 1 for canon (entities, lore, world rules)
- Layer 2 for the campaign plot (story arcs, planned scenes)
- Layer 2 mechanics for the ruleset (HTBAH, D&D, custom)
- Layer 3 for ongoing session state (who's at what HP, what clues have been revealed)

**Roles in the autonomous loop:**

- Tavern handles core game loop (initiative, mechanics, dice resolution, world state)
- Momo (wearing Corset) provides DM voice — narration, character voicing, improvisational decisions
- Remembrance plays NPCs (voice synthesis grounded in lore knowledge)
- Clairvoyance records everything for downstream Remembrance story generation

This is a far-future vision. Out of v1 scope. Documented to ensure Grimoire's data model leaves room for it.

### AI Worldbuilding Partner (Near Future)

Less mature than Tavern but more immediately useful: an AI agent (e.g., Claude / Momo via Corset) that helps the user build Layer 1 and Layer 2.

**Concrete workflows:**

- Ingest a chapter from `sources/`, propose new world/ entries (characters, locations, lore) that the chapter introduces
- Read existing Layer 1, brainstorm Layer 2 plot ideas that exploit unused canon
- Help maintain consistency: check whether a new lore note conflicts with existing canon
- Generate GenAI assets (portraits, location images) tagged with provenance per the `genai` flag

Out of v1 scope to ship as a script, but the vault's structure (clear properties, predictable folder layout, `canon` flag, AGENTS.md in the vault) is designed to make this practical.

#### Concrete agent runtime shape (deferred, but worth designing toward)

When the AI worldbuilding partner becomes a shipped feature, the runtime composition is now well-established (validated separately in the Mikoshi rebuild):

| Component | Role | Scope |
|---|---|---|
| `CLAUDE.md` (already at vault root) | The schema — Karpathy's governance doc. Defines ingest rules, canon conventions, query/answer style. Loaded first by any agent session. | Per-vault |
| `.claude/skills/` (optional, ships with template) | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) (markdown, bases, json-canvas, obsidian-cli, defuddle) as a base, plus a thin Niklas overlay for personal conventions, plus vault-specific skills (e.g. `ttrpg-canon`). | Per-vault |
| `.claude/commands/` (optional, ships with template) | Slash commands shaped to the worldbuilding loop: `/ingest-source-chapter`, `/draft-session-prep`, `/lint-canon`, `/audit-conflicts`. | Per-vault |
| [`aaronsb/obsidian-mcp-plugin`](https://github.com/aaronsb/obsidian-mcp-plugin) | Exposes vault file ops + Bases queries + graph traversal to any MCP client. Read-only mode initially. | Runtime, not in template |
| Local embedding MCP (e.g. [Nooscope](https://www.rodneydyer.com/your-vault-your-vectors-building-a-local-first-mcp-server-for-obsidian/)) | Local Ollama + nomic-embed-text + SQLite. Semantic search across the vault for "what's already canon about X" queries during ingest. | Runtime on Qube, not in template |

The template can ship the `.claude/` scaffold (cross-CLI compatible — Claude Code, Codex, OpenCode all read this directory). The runtime layer (MCP plugin, embedding service) is per-user infrastructure; user installs locally or on Qube.

## v1 Validation Targets

### Hologrammatica (TTRPG)

A TTRPG campaign adapted from Tom Hillenbrand's novel "Hologrammatica," played with HTBAH ruleset, in German.

**Vault shape:**

- `project_type: ttrpg`, `project_mode: adapted-original`, `include_sources: true`
- `world/` — Hillenbrand's universe (characters, post-AI civilization, hologram tech, factions, lore). All `canon: true` by default.
- `sources/` — chapter-by-chapter notes from the novel + curated timeline of what happens
- `story/` — the TTRPG-specific plot arc (different from the novel's plot, uses same world)
- `mechanics/` — HTBAH reference docs (in German) + any house rules
- `play/` — session-prep + session-log + encounter notes for the actual sessions
- User-invented NPCs added for the campaign get `canon: false` (they're not in Hillenbrand's novel)

**What this validates:** the full Layer 1 + 2 + 3 vault for a TTRPG. Bilingual content (German body, English structure). HTBAH ruleset fits in `mechanics/`. The adaptation case (`sources/` + `canon` flag on extracted entities).

### Prisma (Video Game)

A fan-made top-down ARPG built in Godot, drawing from Brent Weeks's Lightbringer series.

**Vault shape:**

- `project_type: video-game`, `project_mode: adapted-original`, `include_sources: true`
- `world/` — Lightbringer entities + lore (Chromeria, Seven Satrapies, drafting magic, factions). All `canon: true` for source material; Prisma-specific additions get `canon: false`.
- `sources/` — Brent Weeks's novels chapter-by-chapter + fandom wiki extracts
- `story/` — Prisma's custom plot, quest design, character arcs
- `mechanics/` — drafting/combat/progression systems, gameplay loops, system design docs
- **(no play/)** — Layer 3 is the Godot game project itself, in `~/Developer/prisma/`

**What this validates:** the no-Layer-3-in-vault case. The vault serves as the design backbone. `mechanics/` carries real weight (gameplay design). The vault might end up referenced from the Godot project as a design source-of-truth.

## Future Media (Not v1)

The data model is designed to accommodate these without redesign:

### Novel

- `project_type: novel` (future Copier option)
- `world/` + `sources/` (if adapting) + `story/` (chapter outlines + arcs) + `mechanics/` skipped + `chapters/` as Layer 3 (the actual prose)

### Screenplay / Series

- `project_type: screenplay`
- `world/` + `sources/` (if adapting) + `story/` (scene breakdown + arcs) + `script/` as Layer 3

### Board Game

- `project_type: board-game`
- `world/` + `story/` (if narrative-driven) + `mechanics/` (the core gameplay) + Layer 3 either as `playtest/` or external (physical components)

Adding any of these is mostly a Copier-conditional update + a few new templates. The three-layer abstraction holds.

## Cross-Galaxy Integrations

### Grimoire + Kindling (philosophical)

Same Copier template philosophy, different domain. Kindling scaffolds Python projects; Grimoire scaffolds Obsidian vaults for creative projects. Both use the `copier update` flow. Both have a "Conjured with X" / "Kindled with X" attribution in generated outputs.

### Grimoire + Qube (infrastructure)

- Qube hosts the AI services (Ollama, ComfyUI, MusicGen, Chatterbox) that produce GenAI assets for the vault
- AI chat in Obsidian (future) runs against local LLMs on Qube
- Remembrance, Clairvoyance, Tavern all live on Qube and read Grimoire vaults stored locally / synced via Gitea

### Grimoire + Mikoshi

- Mikoshi (Niklas's PARA Obsidian vault) is the thinking space
- Grimoire generates project vaults that are NOT in Mikoshi (they're separate Obsidian vaults per project)
- Mikoshi may carry reference notes that link to the Grimoire-generated project vaults
- Convention: Mikoshi's project notes for Hologrammatica and Prisma link to their respective Grimoire vault locations

## Audience-Facing Export Workflow (Future)

The vault is creator-only by default. For TTRPG players, novel readers, screenplay viewers, the future export workflow:

- Walks the vault, filters `canon: true` AND `status: revealed`
- Strips `[!warning]` callouts (creator-only content)
- Outputs HTML site or PDF
- Players / readers / viewers keep this as a memento

For Hologrammatica players: a website per campaign with revealed lore. For Prisma: probably not needed (the game itself is the artifact). For novels: this becomes the actual book.

Deferred to a separate post-v1 milestone.

### Implementation candidate: Quartz (instead of a custom Python export script)

Earlier scoping (see [features.md](features.md) "Future: Audience-Safe Export") imagined a template-side Python script that walks the vault and emits HTML/PDF. A more aligned answer: **[Quartz](https://quartz.jzhao.xyz/)** — a maintained static-site generator built specifically for Obsidian vaults.

| Aspect | Custom Python script | Quartz |
|---|---|---|
| Filtering by `canon` + `status` | Custom code | Quartz frontmatter filtering is native; configurable per build |
| Stripping `[!warning]` callouts | Custom regex | Quartz transformer plugin |
| Output | Static HTML or PDF | Polished static site with backlinks, graph view, search — and PDF export possible per page |
| Live updates | One-shot regen | Quartz rebuilds on push; live player wiki, not memento snapshot |
| Maintenance burden | Grimoire team owns it | Quartz community owns it; we configure |
| Niklas-context fit | Generic | Same tool he wants for the Mikoshi kitchen-RPi read-only view, so one stack serves multiple needs |

**Recommended shape:**

- Static site served from Qube (Niklas's homelab) per generated vault
- Quartz config in the generated vault filters `canon: true` AND `status: revealed`, strips `[!warning]`
- For Hologrammatica: players bookmark the site and browse known lore between sessions; new content appears as the GM updates the vault (rather than as one-shot exports after the campaign ends)
- Site is self-hosted on the home network, no public exposure required

**Open extension worth considering: per-player knowledge scope.** The current `status: revealed` is binary (audience-as-a-group knows or doesn't). For richer player wikis, a `knowledge-scope: public | party-only | character-name` property on individual notes (or `[!warning]` variant callouts) would let Quartz build per-player views. Probably too much for v1, but the data model already mostly accommodates it via existing properties. Worth a note for when the player-wiki use case materialises.
