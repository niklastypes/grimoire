# Grimoire

> Copier template that bootstraps structured Obsidian vaults for creative worldbuilding projects: TTRPG campaigns, video games, novels, screenplays.

Same philosophy as [Kindling](https://github.com/niklastypes/kindling) (Python project template), different domain: Obsidian vaults instead of Python projects. `copier copy` to create, `copier update` to pull template improvements into existing vaults.

## Current Focus

**Layer 1 Ready**: shipped. Vault includes agent scaffold (skills + commands), source ingestion, and canon quality tools (lint-canon, audit-conflicts, Bases views). Next up: Layer 2 (creative workflow).

See [notes/roadmap.md](./notes/roadmap.md) for the full staged plan.

**Prioritization**: Layer 1 first, Layer 2 second, Layer 3 last. Functionality over polish.

## The Three-Layer Model

Every Grimoire vault has three conceptual layers:

| Layer | What it is | Folders | Always present? |
|---|---|---|---|
| **1. Canon** | The universe: entities, lore, source material | `world/` (flat), `sources/` (conditional) | `world/` always; `sources/` when adapting |
| **2. Creative** | What you build on top of canon: plot, systems | `story/`, `mechanics/` | `story/` always; `mechanics/` for games |
| **3. Production** | The deliverable artifact | `play/` for TTRPG | Conditional on project_type |

For video games: Layer 3 is a separate code project (e.g. Godot). The vault stops at Layer 2.

## What Grimoire Generates

```
{{project_name}}/
├── .obsidian/          ← core plugin config (Templates, Bases, Graph View, etc.)
├── .claude/
│   ├── skills/         ← kepano base + grimoire-overlay + <project>-canon skeleton
│   └── commands/       ← ingest-source (more commands planned)
├── world/              ← Layer 1a: entities + lore (flat, no subfolders)
├── sources/            ← Layer 1b: source material (conditional)
├── story/              ← Layer 2a: narrative work (always)
├── mechanics/          ← Layer 2b: systems work (conditional)
├── play/               ← Layer 3: TTRPG production (conditional)
├── assets/
│   ├── images/{characters,locations,items}/
│   ├── audio/{ambient,music,sfx}/
│   └── soundboards/    ← TTRPG only
├── templates/          ← flat, one per type
├── views/              ← Bases .base view files
├── home.md             ← dashboard with Bases embeds
├── world-primer.md     ← player handout (TTRPG only)
├── CLAUDE.md           ← vault governance schema for AI agents
├── README.md           ← "Conjured with Grimoire" + getting started
└── .gitignore          ← Obsidian local-state exclusions
```

## Copier Questions

Lean by design. Player-specific details are filled post-generation.

| Question | Type | Default | Notes |
|---|---|---|---|
| `project_name` | str | | Vault root folder name |
| `project_type` | choice | ttrpg | `ttrpg` / `video-game` / `generic`. Drives Layer 3 and `mechanics/` |
| `project_mode` | choice | original | `original` / `existing-faithful` / `existing-adapted` |
| `genre` | choice | fantasy | fantasy, sci-fi, noir, horror, custom |
| `include_genre_css` | bool | true | Only asked when genre != custom (CSS deferred, captures intent) |
| `include_sources` | bool | auto | Derived from project_mode, never shown to user |

## Design Decisions

| Decision | Choice | Why |
|---|---|---|
| Templating | **Copier** | `copier update` pulls improvements into existing vaults |
| Repo layout | **`_subdirectory: template`** | Separates template content from repo metadata; enables dot directories (.obsidian/, .claude/) |
| Structure | **Three-layer + flat where it matters** | Universal across media; `world/` and `templates/` flat for graph navigation |
| Canon marker | **`canon: true/false` property + `source` attribution** | Bases-queryable; downstream consumers filter for canon-only |
| Character system | **Unified template** | Single `character.md` for PCs/NPCs/any medium; `character-type` differentiates |
| Properties | **Lean frontmatter + body sections** | Dynamic/queryable in frontmatter; rich detail in body |
| View engine | **Bases** | Core plugin; no Dataview dependency |
| Plugin strategy | **Core first, community second, custom third** | Javalent stack for TTRPG deferred to Layer 3 Ready |
| Agent scaffold | **kepano base + grimoire overlay + per-vault project skill** | Three-tier skill stack, each updatable independently |
| Naming | **lowercase kebab-case** | All folders and files |
| Language | **English structure, multilingual content** | Vault structure in English; Layer 1 and 2 content in the same language as the source material |
| Generated vault | **Zero Python dependency** | Python OK template-side only |
| Dot directories | **`--trust` required** | Copier security feature; users prompted on first copy |

## Key Properties

- `type`: `character | location | item | faction | lore | scene | session-prep | session-log | encounter`
- `status`: `draft | ready | revealed | retired`
- `canon`: `true | false` (default true). Is this canonical to the universe?
- `source`: list of wikilinks to source notes (e.g., `["[[chapter-01]]", "[[chapter-03]]"]`). Empty for invented content.
- `faction`: list of wikilinks (characters can belong to multiple factions)
- `leader`: list of wikilinks (factions can have multiple leaders)
- `location` (scenes): list of wikilinks (scenes can span locations)

## Template Repo Layout

```
grimoire/                            (this repo)
├── copier.yml                       # questions + config
├── template/                        # _subdirectory: everything below is copied
│   ├── .obsidian/                   # core plugin config
│   ├── .claude/
│   │   ├── skills/                  # kepano (vendored) + grimoire-overlay + project-canon
│   │   └── commands/                # ingest-source
│   ├── world/
│   ├── sources/                     # conditional
│   ├── story/
│   ├── mechanics/                   # conditional
│   ├── play/                        # conditional
│   ├── assets/
│   ├── templates/
│   ├── views/
│   ├── home.md.jinja
│   ├── world-primer.md.jinja        # conditional (TTRPG)
│   ├── CLAUDE.md.jinja
│   ├── README.md.jinja
│   ├── .gitignore.jinja
│   └── .copier-answers.yml.jinja
├── README.md                        # template repo readme
├── CLAUDE.md                        # this file
├── LICENSE                          # MIT
├── notes/                           # brainstorm + research + roadmap
└── docs/                            # specs + plans
```

## V1 Validation Targets

- A TTRPG campaign adapted from an existing novel, using the HTBAH ruleset
- A fan-made video game (Godot) drawing from an existing book series

## Working on This Repo

- **Conventional commits** (`feat:`, `fix:`, `docs:`, `chore:`)
- **Atomic commits**, one logical change per commit
- **Branch naming**: `feat/add-character-template`, `fix/handle-empty-frontmatter`
- **Test generation** after structural changes: `copier copy --trust --vcs-ref HEAD --defaults --data project_name=test . /tmp/test-vault`
- **Never commit unless asked**
- **`notes/`** is in-flux brainstorm/research (read for deeper context)

## Deeper Context

- [notes/brainstorm/overview.md](./notes/brainstorm/overview.md): vision, three-layer model, canon system, vault structure rationale
- [notes/brainstorm/templates.md](./notes/brainstorm/templates.md): all note templates with properties
- [notes/brainstorm/features.md](./notes/brainstorm/features.md): features by layer, spoiler management, GenAI provenance
- [notes/brainstorm/infrastructure.md](./notes/brainstorm/infrastructure.md): plugin strategy, theming, QA, Copier setup
- [notes/brainstorm/integrations.md](./notes/brainstorm/integrations.md): creative loop, downstream consumers
- [notes/brainstorm/ruleset.md](./notes/brainstorm/ruleset.md): TTRPG-specific HTBAH mechanics
- [notes/research.md](./notes/research.md): Obsidian plugin landscape, v1 plugin selection
- [notes/roadmap.md](./notes/roadmap.md): staged build plan
