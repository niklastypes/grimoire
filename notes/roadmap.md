# Roadmap

> Each stage tagged so `copier update` works from any point.

## Earliest Testable

### Bus Ticket
Repo setup, LICENSE, copier.yml with three-layer question set, notes/ populated.

### Skateboard
Copier template generates the three-layer vault. Folder structure per project_type, all flat templates, `home.md` with real Bases views, `world-primer.md` with genre defaults, `.gitignore`, attributed `README.md`. Open in Obsidian, start writing.

- Slice: copier.yml question set (project_name, project_type, project_mode, genre, genre_theme, include_sources)
- Slice: folder structure with conditional excludes (sources/, mechanics/, play/)
- Slice: flat templates (character, location, item, faction, lore, scene, session-prep, session-log, encounters)
- Slice: Bases view files (all-characters, all-locations, all-factions, all-items, all-lore, canon-only)
- Slice: home.md dashboard with real Bases embeds
- Slice: world-primer.md with genre-appropriate starter content

## Earliest Usable

### Scooter
CSS snippets (infobox callout + genre themes), `.obsidian/` config (core plugins), auto-populated `style-guide.md`, conditional QA tooling (pre-commit, markdownlint), template-side validation/test-generation scripts, CI workflow, release-please.

- Slice: CSS snippets per genre_theme
- Slice: .obsidian/ with core plugin config
- Slice: style-guide.md auto-populated from genre defaults
- Slice: QA scripts (Python, template-side only)
- Slice: CI + release-please

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
