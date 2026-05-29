# Roadmap

> Each stage tagged so `copier update` works from any point.

## Earliest Testable ✓ shipped v0.2.0 (2026-05-29)

### Bus Ticket ✓
Repo setup, LICENSE, copier.yml with three-layer question set, notes/ populated.

### Skateboard ✓
Copier template generates the three-layer vault. Folder structure per project_type, all flat templates, `home.md` with real Bases views, `world-primer.md` for TTRPG players, `.gitignore`, attributed `README.md`, vault `CLAUDE.md` for AI agents, release-please workflow. Open in Obsidian, start writing.

Notable changes from original plan:
- `genre_theme` dropped (deferred to Earliest Usable with CSS)
- `include_sources` derived automatically from `project_mode` (no longer a visible question)
- `include_genre_css` added (asked when genre != custom)
- `world-primer.md` is player-facing (not a creator writing prompt), TTRPG-only
- Vault `CLAUDE.md` added (basic version, improved at Earliest Lovable)
- Templates use static infobox placeholders (no Dataview dependency)
- All templates include collapsible property guides

## Earliest Usable

### Scooter
CSS snippets (infobox callout + genre themes), `.obsidian/` config (core plugins, pre-set Templates folder), auto-populated `style-guide.md`, conditional QA tooling (pre-commit, markdownlint), template-side validation/test-generation scripts, CI workflow.

Note: release-please already shipped with the Skateboard.

- Slice: CSS snippets per genre (driven by `include_genre_css`)
- Slice: .obsidian/ with core plugin config (Templates folder, Bases enabled)
- Slice: style-guide.md auto-populated from genre defaults
- Slice: QA scripts (Python, template-side only)
- Slice: CI workflow (conventional commit validation)

## Earliest Lovable

### Bicycle
Community plugins evaluated and integrated per research.md. Vault health scripts. `copier update` validated on a real vault. `.claude/` agent scaffold shipped (kepano + grimoire-overlay + per-vault skill skeleton + slash commands). CLAUDE.md as the schema.

- Slice: Javalent TTRPG stack pre-configured (Dice Roller, Initiative Tracker, Leaflet, Fantasy Statblocks)
- Slice: audio/soundboard plugin for TTRPG
- Slice: vault health scripts
- Slice: copier update validated (e.g. Hologrammatica gets a Grimoire update)
- Slice: .claude/ agent scaffold + CLAUDE.md schema
- Slice: end-of-project frozen-state pattern documented

## Beyond

- Player-safe export (Layer 3 → HTML/PDF for players, filtered by status/canon)
- AI chat in vault (Copilot for Obsidian or equivalent)
- Vault Gardener nightly cron (adapted from Mikoshi pattern)
- Downstream-consumer integration conventions (Remembrance, Tavern hookup)
- Full Obsidian themes (beyond CSS snippets)
- Novel / screenplay / board game project_types as explicit options
