# Brainstorm: Infrastructure

> Plugin strategy, genre theming, QA tooling, git management, and Copier setup. Most details vary by `project_type` (especially plugin pre-config).

## Plugin Strategy

> [!warning]
> **Plugin decision hierarchy (three tiers, in order):**
>
> 1. **Obsidian core plugin** — if a core plugin can do it (Graph View, Backlinks, Canvas, Bases, Templates, Bookmarks, Properties), use that.
> 2. **Well-known, actively maintained community plugin** — the Javalent TTRPG stack (Dice Roller, Initiative Tracker, Leaflet, Fantasy Statblocks) and similarly canonical plugins are next. Active maintenance + ecosystem fit are non-negotiable.
> 3. **Custom plugin built for Grimoire** — only when both layers above fail to deliver the mechanic we want, AND the mechanic is important enough to justify building+maintaining a plugin.
>
> Keep dependencies minimal. Don't reach for tier 3 just because it's interesting.

### Core Plugins (always)

- **Graph View**: visualize relationships between entities
- **Backlinks**: contextual navigation ("where is this character mentioned?")
- **Canvas**: faction maps, relationship webs, plot structures built visually
- **Bases**: database views for entity lists, layer-specific views, custom filters. **The bet for the v1 view layer.** Dataview kept as targeted fallback only.
- **Templates**: consistent note creation
- **Bookmarks**: quick access to dashboards
- **Properties**: frontmatter-based metadata

### Community Plugin Evaluation (varies by project_type)

**Detailed plugin research lives in [research.md](research.md).** Plugin pre-config in `.obsidian/` ships at Earliest Lovable, gated on `project_type`.

#### TTRPG project_type — Javalent stack pre-configured

- Dice Roller — d10, d100, custom expressions (HTBAH-friendly)
- Initiative Tracker — combat turn order
- Leaflet — interactive maps with creature markers
- Fantasy Statblocks — D&D-style statblocks (custom layout for HTBAH at Earliest Usable)
- RPG Audio or TTRPG Tools: Soundboard — soundboards per scene

#### Video-game project_type — minimal plugin pre-config

- Canvas (core, always) — for system diagrams, dependency graphs
- Timeline (optional, future) — chronology of the game's narrative timeline
- No TTRPG-flavored plugins (Dice Roller, Initiative Tracker, etc. — irrelevant)

#### Generic project_type — minimal plugin pre-config

- Core only. User adds whatever fits their actual project.

### CSS Snippets (shipped at Earliest Usable)

- **wiki-entry infobox**: right-floating callout with portrait and key data, Fandom Wiki style
- **genre themes**: genre-specific vault styling (cyberpunk, fantasy, noir, horror, sci-fi, neutral)
- **theme-variables**: custom hex codes override (when `genre_theme=custom`)

**Snippet vs full theme**: snippets layer on top of the user's chosen Obsidian theme. Full themes deferred to post-v1.

## Genre Theming

> [!tip]
> The vault's visual identity matches the project's genre. Pre-built CSS themes ship with the template, selectable during Copier setup. Custom hex codes available for full control.

### Pre-built Themes

- **cyberpunk**: dark background, neon accents (cyan, magenta, lime), monospace headers
- **fantasy**: warm tones, parchment-like backgrounds, serif heading fonts, earthy accents
- **noir**: high contrast black/white, gold accents, elegant serif fonts
- **horror**: very dark, red accents, tight margins, unsettling font choices
- **sci-fi**: clean, minimalist, blue accents, monospace elements
- **neutral**: clean default, no genre-specific styling

### Custom Colors

- During Copier setup, users can provide custom hex codes (primary, secondary, accent) instead of a preset
- Custom colors written into `.obsidian/snippets/theme-variables.css` overriding the preset
- Style guide auto-populated with matching palette for consistent GenAI asset generation

### Future Enhancement

- A `theme.yml` config file that both the CSS snippet and `style-guide.md` prompt presets read from, so changing one color propagates everywhere
- Full Obsidian themes (vs. snippets) for more aggressive visual customization

## Quality Assurance & CI

> [!tip]
> Developer-friendly tooling for keeping the vault clean. Optional, can be removed by non-technical users.

**Language policy:**

- **Generated vault has ZERO Python dependency.** Obsidian + markdown only.
- **Template-side tooling (validation, test-generation, vault health checks) may use Python freely.** It runs against the template repo or a freshly-generated vault; the user maintaining the template is the audience, not the project creator.
- **bash is still acceptable** for simple checks. Use whichever fits the task — Python for parsing frontmatter, bash for filesystem walks.

### Pre-commit Hooks (Earliest Usable, conditional on `include_qa`)

- **markdownlint**: consistent formatting (trailing newlines, heading levels, list style)
- **frontmatter validation**: required properties present on all entity notes (`type`, `status`, `canon`)
- **broken link check**: verify `[[backlinks]]` point to existing notes

### CI / Vault Health Scripts (Earliest Lovable)

Runnable via GitHub Actions or locally. Python and/or bash (template-side):

- **orphan asset check**: images/audio in `assets/` not referenced by any note
- **orphan note check**: entities not linked from any scene, session, or other note
- **property completeness**: notes with missing or empty required properties
- **canon consistency**: entities with `canon: false` linked from canonical lore (suspicious)
- **status consistency**: e.g., revealed clue with empty `held-by`
- **template drift**: existing note structures vs. their templates

> [!tip]
> **Forward-looking:** these scripts are v1's deliverable, but they're also the foundation of the **Vault Gardener** pattern documented in [features.md](features.md#vault-gardener-future). Design them so they're runnable on a schedule and emit machine-readable output (JSON or a briefing markdown note), not just CLI text. That way the same checks compose into nightly cron runs later without rewriting.

### Shipped Tooling

- pre-commit config (`.pre-commit-config.yaml`)
- vault health scripts (Python and/or bash, template-side)
- GitHub Actions workflow (template repo, runs `test-generate`)
- `.markdownlint.yml` with project-specific rules

## Git & .obsidian Management

> [!warning]
> `.obsidian/` contains both template-managed config and Obsidian-managed local data. The `.gitignore` must separate these cleanly.

### What to Version (template-managed)

- `snippets/` (CSS snippets for infobox, genre theme)
- `plugins/*/data.json` (plugin config files)
- `app.json` (core Obsidian settings)
- `appearance.json` (theme, font, snippet activation)
- `community-plugins.json` (list of enabled community plugins)
- `core-plugins.json` (list of enabled core plugins)
- `templates.json` (template folder config)
- `views/*.base` (Bases view definitions)

### What to .gitignore (Obsidian-managed local data)

- `workspace.json` (window layout, open tabs, sidebar state)
- `workspace-mobile.json`
- `graph.json` (graph view position/zoom)
- `backlink.json`
- `hotkeys.json` (user-specific keybindings)
- plugin runtime data (caches, indexes, local state)

### .gitignore Template

```gitignore
# Obsidian local state
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/graph.json
.obsidian/backlink.json
.obsidian/hotkeys.json

# Plugin runtime data (keep config, ignore caches)
.obsidian/plugins/*/cache/
.obsidian/plugins/*/index/
.obsidian/plugins/*/.data/

# OS
.DS_Store
Thumbs.db
```

> [!warning]
> The exact ignore patterns need validation during implementation. Some plugins store config and cache in the same directory, which may require more granular rules.

## Agent Runtime Layer

> [!tip]
> **Principle: every generated vault is agent-ready out of the box.** The Copier template ships a `.claude/` scaffold (skills + commands + schema framing) as part of Earliest Lovable. The marginal cost of including files in the template output is near-zero; the marginal value is large — the moment a creator generates a vault, an agent (Claude Code, Codex CLI, OpenCode) can read the schema, follow the conventions, and execute the worldbuilding loop. No separate setup, no "bring your own agent config."

This pattern is validated separately by the Mikoshi rebuild (see [mikoshi/design.md](../../mikoshi/design.md) Layer 2). Grimoire applies the same shape to *template-generated* creative vaults instead of a daily-driver PKM.

### What ships with the template

```
{{project_name}}/
├── .claude/
│   ├── skills/
│   │   ├── obsidian-markdown/      ← from kepano/obsidian-skills (markdown, wikilinks, callouts)
│   │   ├── obsidian-bases/         ← from kepano/obsidian-skills
│   │   ├── obsidian-cli/           ← from kepano/obsidian-skills
│   │   ├── json-canvas/            ← from kepano/obsidian-skills (Canvas file format)
│   │   ├── defuddle/               ← from kepano/obsidian-skills (web extraction)
│   │   ├── grimoire-overlay/       ← Grimoire-shipped: three-layer awareness, canon-flag rules,
│   │   │                              folder-note vocabulary, property schema
│   │   └── <project>-canon/        ← per-vault, Copier-generated skeleton for project-specific
│   │                                  conventions (e.g. lightbringer-canon for Prisma)
│   └── commands/
│       ├── ingest-source-chapter.md   ← universal: ingest a source into world/ + sources/
│       ├── lint-canon.md              ← universal: canon-consistency + property completeness
│       ├── audit-conflicts.md         ← universal: surface contradictions across canon entries
│       ├── draft-session-prep.md      ← (when project_type == ttrpg)
│       └── plan-mechanic.md           ← (when project_type ∈ {ttrpg, video-game})
├── CLAUDE.md                          ← The schema (Karpathy governance doc). Loaded first by
│                                         any agent session. Defines the three-layer model,
│                                         canon conventions, ingest rules, query/answer style.
```

#### The three-tier skill stack

| Tier | Source | What it contains | Update mechanism |
|---|---|---|---|
| **1. Upstream base** | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) (git submodule or vendored copy) | Generic Obsidian conventions: markdown formatting, wikilinks, callouts, Bases syntax, obsidian-cli usage, Canvas format, web extraction | `copier update` pulls newer kepano snapshots |
| **2. Grimoire overlay** | Template-shipped (`grimoire-overlay/`) | Worldbuilding-specific conventions on top of kepano: three-layer model awareness, `canon`/`source`/`status` flag rules, folder-note vocabulary, when-to-use-which-template | Versioned with the Grimoire template; `copier update` propagates |
| **3. Per-vault project skill** | Copier-generated skeleton (`<project>-canon/`) | Vault-specific facts: canonical entity naming, ruleset specifics, in-universe terminology, "don't confuse X with Y" notes | Creator fills in over time; Copier never overwrites |

**Why three tiers and not two:** kepano changes, Grimoire's worldbuilding conventions change, and each project's canon-specific rules change — on *different* cadences. Collapsing tiers means upstream kepano updates would clobber Grimoire conventions, or Grimoire updates would clobber project-specific knowledge. Three layers keeps each independently updatable.

- **Cross-CLI compatibility.** The `.claude/` directory convention is read by Claude Code, Codex CLI, OpenCode, etc. One scaffold serves multiple agent tools.
- **CLAUDE.md is the schema, not documentation.** It's loaded by the agent on session start as the governance contract — folder structure, naming conventions, property semantics, when to create new entries vs link to existing ones. Karpathy's PKM pattern applied to creative work.
- **Vault-specific commands.** Grimoire's commands encode the worldbuilding loop: ingest from sources, draft session prep, lint canon, audit conflicts. These reference the existing `canon`, `source`, `status` properties — they don't introduce new ones.

### Runtime infrastructure (user-side, not in template)

The template ships the *scaffold*. The runtime that consumes it lives wherever the user runs their AI:

- **[aaronsb/obsidian-mcp-plugin](https://github.com/aaronsb/obsidian-mcp-plugin)** — exposes vault file ops, Bases queries, graph traversal as MCP tools. Bearer-token auth on localhost. Start in read-only mode; promote to write after trust is established.
- **Local embedding MCP** (e.g. [Nooscope](https://www.rodneydyer.com/your-vault-your-vectors-building-a-local-first-mcp-server-for-obsidian/)) — Ollama + nomic-embed-text + SQLite. Semantic search for "what's already canon about X" queries during ingest, "find related entities" during connection enrichment. Local-first.

These are not Python dependencies in the vault (per the zero-Python-in-vault rule). They're external services the user runs separately (typically on Qube for Niklas's setup).

### Shipped vs user-provided demarcation

| Layer | Where it lives | Who owns it |
|---|---|---|
| Vault content (Layers 1-3) | Generated vault, in git | Creator |
| `.claude/skills/` (kepano base + grimoire overlay) | Generated vault, in git | Grimoire template (via `copier update`) |
| `.claude/skills/<project>-canon/` | Generated vault, in git | Creator (fills in over time) |
| `.claude/commands/` | Generated vault, in git | Grimoire template |
| `CLAUDE.md` (schema) | Generated vault, in git | Grimoire template (with per-vault personalization slots) |
| MCP plugin (obsidian-mcp-plugin) | Runtime infrastructure | User installs in Obsidian |
| Embedding service (Nooscope) | Runtime infrastructure (Qube or localhost) | User runs externally |
| Agent CLI (Claude Code / Codex / OpenCode) | Runtime infrastructure | User runs externally |

**The dividing line:** anything that should be version-controlled with the vault (because it defines conventions or commands) ships with the template. Anything that's an external service or per-machine install is user-provided.

### Three-tier plugin strategy still applies

The runtime layer doesn't conflict with the existing plugin strategy. obsidian-mcp-plugin is a tier-2 well-maintained community plugin; embedding services are out-of-Obsidian altogether. **No custom Grimoire plugin is required to make a vault agent-ready.** The scaffold + community plugins + external MCP services do the work.

### Status

Planned for **Earliest Lovable**. The kepano skill ingestion (Tier 1) and Grimoire overlay (Tier 2) ship as soon as the skill content is drafted; the per-vault project skill (Tier 3) ships as a Copier-generated skeleton from day one (empty but present). Slash commands are scoped sequentially: `lint-canon` and `ingest-source-chapter` first (universal, low risk), then project_type-conditional commands.

## Copier Template Setup

When bootstrapping a new project, the following questions are asked. Lean by design — minimum upfront friction. Project-specific details (player count, character names, etc.) are filled in post-generation.

- **project_name**: name of the project (vault root folder)
- **project_type**: `ttrpg` / `video-game` / `generic`. Drives Layer 2b (`mechanics/`) and Layer 3 (`play/`) inclusion plus plugin pre-config
- **project_mode**: `original` / `existing-universe` / `adapted-original`. Drives `include_sources` default
- **genre**: fantasy / sci-fi / noir / horror / custom
- **genre_theme**: cyberpunk / fantasy / noir / horror / sci-fi / neutral / custom
- **custom_primary / custom_secondary / custom_accent**: hex codes if `genre_theme=custom`
- **include_sources**: auto-true for `existing-universe` and `adapted-original`; user can override
- **include_agent_scaffold**: default `true`. Ships `.claude/skills/` (kepano base + grimoire overlay + per-vault skeleton) and `.claude/commands/`. Set to `false` only if the creator explicitly does not want agent-tooling files in their vault (rare; the scaffold is inert without a runtime).

### What Copier Generates

**Earliest Testable:**

- Layered folder structure conditional on `project_type` and `include_sources`
- All flat templates in `templates/`
- Real Bases `.base` view files in `views/`
- `home.md` with project-state frontmatter and Bases view embeds
- `world-primer.md` with genre defaults
- `README.md` with "Conjured with Grimoire" attribution
- `.gitignore`
- `.copier-answers.yml`

**Earliest Usable adds:**

- `.obsidian/` config with core plugins enabled, CSS snippets activated, conditional community plugin pre-config (per `project_type`)
- CSS snippets (wiki-entry infobox, per-genre theme)
- `style-guide.md` auto-populated with genre defaults
- Conditional `trailer.md` (Copier question `include_trailer`)
- HTBAH ruleset reference in `mechanics/` (when ttrpg and chosen)
- QA tooling (if `include_qa=true`): `.pre-commit-config.yaml`, `.markdownlint.yml`
- (Template-side) validation and test-generation scripts, CI workflow, release-please

**Earliest Lovable adds:**

- `.claude/` scaffold (if `include_agent_scaffold=true`, default): kepano skill base + grimoire-overlay + `<project>-canon/` skeleton + universal commands + project_type-conditional commands. See [Agent Runtime Layer](#agent-runtime-layer) above for the full structure.
- CLAUDE.md authored as the schema (Karpathy governance doc), not just per-project documentation

## Open Questions

- Exact `home.md` dashboard layout (which Bases views, ordering, columns) — needs prototyping during Task 5
- Exact CSS snippet details: infobox styling, per-genre theme implementations — design + iteration
- Exact `.gitignore` patterns for `.obsidian/` plugin runtime data — per-plugin validation
- Whether to ship a "getting started" guide for the project creator as a README inside the generated vault (separate from `world-primer.md`)
- Granularity of genre defaults for `style-guide.md` auto-population — how detailed at Copier-time vs. left for the user to refine?

For plugin selection per project_type, see [research.md](research.md).
