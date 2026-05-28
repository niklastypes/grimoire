# 📜 Grimoire

> The worldbuilder's grimoire. Bootstrap a structured Obsidian vault for any creative project: TTRPG campaigns, video games, board games, novels, screenplays. Build a world once, use it for many things.

A [Copier](https://copier.readthedocs.io/) template that generates Obsidian vaults organized in three layers: canon (the universe), creative (what you build on top), and production (the artifact you ship). Works for Pen & Paper systems (like HTBAH), Dungeons & Dragons, video games (the vault becomes the design backbone, code lives elsewhere), and other creative media.

## Status

**Pre-v0.1** — under active development. See [notes/](./notes/) for the full design docs.

## Quick Start

```bash
# Create a new project vault
copier copy gh:niklastypes/grimoire my-project

# Update an existing vault with template improvements
cd my-project
copier update
```

You'll be asked a few questions:

- `project_name` — vault root folder name
- `project_type` — `ttrpg` / `video-game` / `generic`. Drives which layer-3 folders get created.
- `project_mode` — `original` / `existing-universe` / `adapted-original`. Determines whether `sources/` is included.
- `genre` — fantasy / sci-fi / noir / horror / custom
- `genre_theme` — visual theme for the vault
- `include_sources` — auto-derived from project_mode; can be overridden

The result is a vault with `world/`, `story/`, conditional `sources/`, `mechanics/`, `play/`, plus `assets/`, `templates/`, `views/`, and a Bases-driven `home.md` dashboard.

## The Three-Layer Model

Every Grimoire vault is organized around three layers:

| Layer | What it is | Folders |
|---|---|---|
| **1. Canon** | The universe, entities, lore, original source material | `world/` (entities + lore), `sources/` (source material when adapting) |
| **2. Creative** | The unique work you build on top of canon | `story/` (plot, scenes), `mechanics/` (systems, rules) |
| **3. Production** | The deliverable. Sometimes in the vault (TTRPG sessions, novel chapters), sometimes outside (video game code) | `play/` for TTRPG |

For a TTRPG like Hologrammatica: all three layers live in the vault. For a video game like Prisma: layers 1 and 2 in the vault, layer 3 (the actual game code) in a separate project.

## What You Get

A new project vault with:

- **Flat `world/`** for graph-shaped entities (characters, locations, items, factions, lore) navigated via Bases queries, not folder hierarchies
- **`sources/`** (conditional) for raw and curated source material when adapting from existing media
- **`story/` for narrative work** — plot arcs, scenes, character arcs specific to your project
- **`mechanics/`** (when relevant) for systems/rules/gameplay design
- **`play/`** (TTRPG only) for session-prep, session-log, and encounter notes
- **`assets/`** with image/audio organization, plus soundboards when TTRPG
- **Flat `templates/`** — one of each type, picked via Obsidian's template plugin
- **Bases-driven `home.md` dashboard** with views for every entity type and layer
- **`world-primer.md`** with genre-appropriate starter content

Every entity carries a `canon: true | false` property so downstream consumers (you, AI agents, Remembrance, future Tavern) can distinguish canonical-to-the-world content from project-specific inventions.

## Beyond the Vault

Grimoire's strategic positioning: **the universal data substrate for an entire creative ecosystem.** Multiple downstream consumers can read the vault:

- **You** (or an AI worldbuilding partner) — build Layer 2 on top of Layer 1
- **Remembrance** — reads canon to generate lore audio in the universe
- **Clairvoyance** — records actually-played TTRPG sessions; artifacts feed back to Remembrance for "stories from our played campaign"
- **Tavern** (future) — AI Dungeon Master that consumes a vault and runs sessions autonomously

The vault is the data; everything else reads it.

## Design Principles

- **Core Obsidian plugins first.** Community plugins (Dice Roller, Audio Player, Initiative Tracker, Leaflet, Fantasy Statblocks) ship pre-configured in `.obsidian/` at Earliest Lovable, gated on `project_type == 'ttrpg'`. Custom plugins are a third-tier option only when both layers fail.
- **Bases is the bet.** Database views replace manual glossaries.
- **`canon` as a property, not a folder.** Lets one folder structure handle both adapted and original projects cleanly.
- **`copier update`-friendly.** Template improvements flow into existing vaults via Copier.
- **Agent-navigable.** Designed to be consumed by coding agents, AI worldbuilders, and downstream services as much as by humans.

## License

[MIT](./LICENSE)
