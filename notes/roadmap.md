# Roadmap

> Each stage tagged so `copier update` works from any point.

## Prioritization Principle

**Layer 1 first, Layer 2 second, Layer 3 last.** Functionality over polish. Each increment should deliver a testable vertical slice of real worldbuilding workflow, validated against Hologrammatica (TTRPG, adapted) and Prisma (video-game, adapted).

## Earliest Testable ✓ shipped v0.2.0 (2026-05-29)

### Bus Ticket ✓
Repo setup, LICENSE, copier.yml with three-layer question set, notes/ populated.

### Skateboard ✓
Copier template generates the three-layer vault. Folder structure per project_type, all flat templates, `home.md` with real Bases views, `world-primer.md` for TTRPG players, `.gitignore`, attributed `README.md`, vault `CLAUDE.md` for AI agents, release-please workflow. Open in Obsidian, start writing.

Notable changes from original plan:
- `genre_theme` dropped (deferred to CSS polish milestone)
- `include_sources` derived automatically from `project_mode` (no longer a visible question)
- `include_genre_css` added (asked when genre != custom)
- `world-primer.md` is player-facing (not a creator writing prompt), TTRPG-only
- Vault `CLAUDE.md` added (basic version, improved later)
- Templates use static infobox placeholders (no Dataview dependency)
- All templates include collapsible property guides

## Layer 1 Ready ✓ shipped v0.4.0

### Source Ingestion ✓
The vault becomes a real worldbuilding tool. Scaffold a vault, ingest source material, get structured entities in `world/`.

- `.obsidian/` config: core plugins enabled, Templates folder pre-set, expanded `.gitignore`
- `.claude/skills/`: kepano base (vendored, MIT), grimoire overlay, per-vault project skill skeleton
- `ingest-source` command: handles narrative sources (novel chapters) and wiki-style sources (fandom wiki extracts), creates/updates entities in `world/`, manages `sources/` notes
- `ingest-source` v2: writes a compact per-source summary into each source note + maintains a running story digest (`sources/_digest.md`) so downstream skills don't need to re-read raw chapters. See [brainstorm/features.md#source-summaries-running-story-digest](brainstorm/features.md#source-summaries-running-story-digest).
- Upgraded vault `CLAUDE.md`: becomes the real schema (ingest rules, canon conventions, entity creation guidelines)

### Canon Quality ✓
Keep Layer 1 consistent as content grows.

- `lint-canon` command: property completeness, canon consistency, wikilink health, orphan entity detection
- `audit-conflicts` command: contradictions, duplicates, relationship gaps across canon entries
- Bases views: clues & secrets, by-source attribution, unrevealed secrets
- Commands reference + recommended workflow guide in vault CLAUDE.md and README
- Content language rule: Layer 1/2 content matches source material language

## Layer 2 Ready (future)

### Creative Workflow
Build story and mechanics on top of canon.

- `compose-scene` skill: turns canon + optional source slice into a table-ready scene note (Intro to read aloud, beat table, NPC voice cheat, refusal branch, hooks-out, GM-only worldbuilding checklist). Two modes: adaptation (source-driven) and original (brainstorm). Optionally emits `.canvas` + handouts in `play/`. Empirically validated on Hologrammatica Szene 01. See [brainstorm/scene-composition.md](brainstorm/scene-composition.md).
- `compose-session` skill: bundles 2–5 scenes into a pacing-aware session, surfaces cross-scene prep needs, produces a `session-prep` note.
- Mechanics templates/guidance for TTRPG (HTBAH) and video-game
- `style-guide.md` auto-populated from genre (for GenAI asset consistency)
- Canvas templates for relationship webs, faction maps, plot structures

## Layer 3 Ready (future, TTRPG-specific)

### Session Play
Run actual TTRPG sessions from the vault.

- Javalent TTRPG stack pre-configured (Dice Roller, Initiative Tracker, Leaflet, Fantasy Statblocks)
- Audio/soundboard plugin for immersion
- Session management improvements
- `world-primer.md` enhancements for player handouts

## Polish (future, orthogonal)

Can be done at any point, not blocking functionality.

- CSS snippets (infobox callout + genre themes, driven by `include_genre_css`)
- Full `.obsidian/` appearance config (theme, fonts)
- QA tooling (pre-commit, markdownlint, CI workflow)
- `copier update` validated on real vaults
- End-of-project frozen-state pattern

## Beyond

- Player-safe export (Quartz static site, filtered by status/canon)
- AI chat in vault (Copilot for Obsidian or equivalent)
- Vault Gardener nightly cron (adapted from Mikoshi pattern)
- Downstream-consumer integration conventions (Remembrance, Tavern hookup)
- Full Obsidian themes (beyond CSS snippets)
- Novel / screenplay / board game project_types
