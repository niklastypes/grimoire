# Grimoire

> Copier template that bootstraps structured Obsidian vaults for creative worldbuilding projects: TTRPG campaigns, video games, novels, screenplays.

Same philosophy as [Kindling](https://github.com/niklastypes/kindling) (Python project template), different domain: Obsidian vaults instead of Python projects. `copier copy` to create, `copier update` to pull template improvements into existing vaults.

## Current Focus

**Layer 1 Ready (Source Ingestion)**: Make the vault a real worldbuilding tool. Agent scaffold (kepano skills + grimoire overlay + ingest-source command) so you can scaffold a vault, ingest source material, and get structured entities in `world/`. Validated against Hologrammatica and Prisma.

Earliest Testable (Skateboard) shipped as v0.2.0. See [notes/roadmap.md](./notes/roadmap.md) for the full staged plan.

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
├── world-primer.md     ← Layer 1 setup primer
├── style-guide.md      ← visual + tonal identity (Earliest Usable)
├── README.md           ← "Conjured with Grimoire" attribution
└── .gitignore          ← Obsidian local-state exclusions
```

## Copier Questions

Lean by design. Player-specific details are filled post-generation.

| Question | Type | Default | Notes |
|---|---|---|---|
| `project_name` | str | | Vault root folder name |
| `project_type` | choice | ttrpg | `ttrpg` / `video-game` / `generic`. Drives Layer 3 and `mechanics/` |
| `project_mode` | choice | original | `original` / `existing-universe` / `adapted-original`. Drives `include_sources` |
| `genre` | choice | fantasy | fantasy, sci-fi, noir, horror, custom |
| `genre_theme` | choice | neutral | cyberpunk, fantasy, noir, horror, sci-fi, neutral, custom |
| `include_sources` | bool | auto | Auto-true for existing-universe/adapted-original |

## Design Decisions

| Decision | Choice | Why |
|---|---|---|
| Templating | **Copier** | `copier update` pulls improvements into existing vaults |
| Structure | **Three-layer + flat where it matters** | Universal across media; `world/` and `templates/` flat for graph navigation |
| Canon marker | **`canon: true/false` property + `source` attribution** | Bases-queryable; downstream consumers filter for canon-only |
| Character system | **Unified template** | Single `character.md` for PCs/NPCs/any medium; `type` differentiates |
| Properties | **Lean frontmatter + body tables** | Dynamic/queryable in frontmatter; rich detail in body |
| View engine | **Bases** | Core plugin; no Dataview dependency |
| Plugin strategy | **Core first, community second, custom third** | Javalent stack for TTRPG at Earliest Lovable |
| Visual style | **Wiki-entry infobox** via CSS snippet | Fandom Wiki style, `[!infobox]` callout |
| Naming | **lowercase kebab-case** | All folders and files |
| Language | **English structure, multilingual content** | Vault structure in English; content in any language |
| Generated vault | **Zero Python dependency** | Python OK template-side only |

## Key Properties

- `type`: `pc | npc | location | item | faction | lore | scene | session-prep | session-log | encounter`
- `status`: `draft | ready | revealed | retired` (entities), `active` (PCs), `in-progress | completed` (project)
- `canon`: `true | false` (default true). Is this canonical to the universe?
- `source`: attribution string (`"Hillenbrand 2018"`, `"self"`)
- `genai`: `true | false`. AI-generated content provenance flag.

## Template Repo Layout

```
grimoire/                            (this repo)
├── copier.yml                       # questions + config (excluded from copy)
├── README.md                        # template repo readme (excluded from copy)
├── CLAUDE.md                        # this file (excluded from copy)
├── LICENSE                          # MIT (excluded from copy)
├── notes/                           # brainstorm + research + roadmap (excluded from copy)
│
│   ── template files below are copied to generated vault ──
│
├── world/
├── sources/                         # conditional
├── story/
├── mechanics/                       # conditional
├── play/                            # conditional
├── assets/
├── templates/
├── views/
├── home.md.jinja
├── world-primer.md.jinja
├── README.md.jinja
├── .gitignore.jinja
└── .copier-answers.yml.jinja
```

## V1 Validation Targets

- **Hologrammatica**: Tom Hillenbrand adaptation, TTRPG (HTBAH ruleset), German content
- **Prisma**: Brent Weeks Lightbringer fan ARPG, video-game project_type

## Working on This Repo

- **Conventional commits** (`feat:`, `fix:`, `docs:`, `chore:`)
- **Atomic commits**, one logical change per commit
- **Branch naming**: `feat/add-character-template`, `fix/handle-empty-frontmatter`
- **Test generation** after structural changes: `copier copy --defaults . /tmp/test-vault`
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
- [notes/roadmap.md](./notes/roadmap.md): staged build plan (ET/EU/EL)
