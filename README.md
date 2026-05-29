# 📜 Grimoire

> The worldbuilder's grimoire. Bootstrap a structured Obsidian vault for any creative project: TTRPG campaigns, video games, board games, novels, screenplays. Build a world once, use it for many things.

A [Copier](https://copier.readthedocs.io/) template that generates Obsidian vaults organized in three layers: canon (the universe), creative (what you build on top), and production (the artifact you ship). Works for Pen & Paper systems (like HTBAH), Dungeons & Dragons, video games (the vault becomes the design backbone, code lives elsewhere), and other creative media.

## Quick Start

```bash
# Create a new project vault
copier copy --trust gh:niklastypes/grimoire my-project

# Update an existing vault with template improvements
cd my-project
copier update --trust
```

> The `--trust` flag is required because Grimoire ships dot directories (`.obsidian/`, `.claude/`) in generated vaults.

You'll be asked a few questions:

- `project_name` — vault root folder name
- `project_type` — `ttrpg` / `video-game` / `generic`
- `project_mode` — `original` / `existing-faithful` / `existing-adapted`
- `genre` — fantasy / sci-fi / noir / horror / custom

The result is a vault with `world/`, `story/`, conditional `sources/`, `mechanics/`, `play/`, plus `assets/`, `templates/`, `views/`, a Bases-driven `home.md` dashboard, and an agent scaffold in `.claude/`.

## The Three-Layer Model

Every Grimoire vault is organized around three layers:

| Layer | What it is | Folders |
|---|---|---|
| **1. Canon** | The universe, entities, lore, original source material | `world/` (entities + lore), `sources/` (source material when adapting) |
| **2. Creative** | The unique work you build on top of canon | `story/` (plot, scenes), `mechanics/` (systems, rules) |
| **3. Production** | The deliverable. Sometimes in the vault (TTRPG sessions), sometimes outside (video game code) | `play/` for TTRPG |

For a TTRPG campaign: all three layers live in the vault. For a video game: layers 1 and 2 in the vault, layer 3 (the actual game code) in a separate project.

## What You Get

A new project vault with:

- **Flat `world/`** for graph-shaped entities (characters, locations, items, factions, lore) navigated via Bases queries, not folder hierarchies
- **`sources/`** (conditional) for raw and curated source material when adapting from existing media
- **`story/` for narrative work** — plot arcs, scenes, character arcs specific to your project
- **`mechanics/`** (when relevant) for systems/rules/gameplay design
- **`play/`** (TTRPG only) for session-prep, session-log, and encounter notes
- **`assets/`** with image/audio organization, plus soundboards when TTRPG
- **Flat `templates/`** — one per entity type, picked via Obsidian's template plugin
- **Bases-driven `home.md` dashboard** with views for every entity type
- **`.obsidian/` config** — core plugins pre-configured, Templates folder set, no manual setup
- **`.claude/` agent scaffold** — kepano Obsidian skills, Grimoire overlay, per-vault project canon skill, and the `ingest-source` command
- **`world-primer.md`** (TTRPG) — player handout for session 1

Every entity carries a `canon: true | false` property so downstream consumers (you, AI agents, Remembrance, future Tavern) can distinguish canonical-to-the-world content from project-specific inventions.

## Agent-Ready Worldbuilding

Generated vaults ship with a `.claude/` scaffold that makes them immediately usable with AI coding agents (Claude Code, Codex, OpenCode):

- **`/ingest-source`** — ingest a novel chapter or wiki page, extract entities into `world/` with proper frontmatter and wikilinks
- **Grimoire overlay skill** — teaches agents the three-layer model, canon rules, and property schema
- **Per-vault project skill** — empty skeleton for project-specific canon rules, filled in as your world grows

## Beyond the Vault

Grimoire's strategic positioning: **the universal data substrate for an entire creative ecosystem.** Multiple downstream consumers can read the vault:

- **You** (or an AI worldbuilding partner) — build Layer 2 on top of Layer 1
- **Remembrance** — reads canon to generate lore audio in the universe
- **Clairvoyance** — records actually-played TTRPG sessions
- **Tavern** (future) — AI Dungeon Master that consumes a vault and runs sessions autonomously

The vault is the data; everything else reads it.

## Design Principles

- **Core Obsidian plugins first.** Community plugins deferred to later milestones.
- **Bases is the bet.** Database views replace manual glossaries.
- **`canon` as a property, not a folder.** One structure handles both adapted and original projects.
- **`copier update`-friendly.** Template improvements flow into existing vaults.
- **Agent-navigable.** Every vault ships agent-ready with `.claude/` scaffold and governance `CLAUDE.md`.

## License

[MIT](./LICENSE)
