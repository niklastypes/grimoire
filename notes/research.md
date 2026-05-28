# Research

> Obsidian plugin landscape, candidate evaluation per category, and v1 plugin set recommendations by `project_type`.

## Why this doc exists

Grimoire's brainstorm listed several community plugins as "to evaluate" with no decisions. That's a lot of unmade choices for what gets pre-configured in the generated vault's `.obsidian/`. This doc evaluates each category and lands a v1 selection.

**Crucially, plugin pre-config varies by `project_type`:**

- **TTRPG**: the Javalent stack (Dice Roller, Initiative Tracker, Leaflet, Fantasy Statblocks) plus an audio/soundboard plugin
- **Video-game**: minimal community plugins (Canvas core, optionally Timeline). TTRPG-flavored plugins (dice, initiative tracker, soundboard) are not relevant.
- **Generic**: core plugins only. User adds whatever fits.

The bulk of this doc evaluates the TTRPG plugin landscape since that's where the heaviest plugin investment lives. Video-game and generic projects largely rely on Obsidian core.

**Plugin decision hierarchy (Grimoire-wide policy, applies to this doc and future plugin decisions):**

1. **Obsidian core first** — if a core plugin solves the need, that's the answer.
2. **Well-maintained community plugins** — when core can't do it. Active maintenance + ecosystem fit are non-negotiable.
3. **Custom Grimoire plugin** — only when both layers above fail AND the mechanic is important enough to justify building+maintaining the plugin.

Tier 3 (custom) is a real option, not a forbidden one. Just don't reach for it because building plugins sounds fun — reach for it because the gap is real and the value justifies the maintenance cost.

**Within tier 2, selection criteria (weighted in order):**

1. **Active maintenance** — last release within ~6 months, responsive issues. Abandonware is worse than not shipping anything.
2. **Integrates with the Javalent TTRPG stack** — Dice Roller, Fantasy Statblocks, Initiative Tracker, Leaflet are designed to interlock. Adopting one and a non-Javalent sibling fragments the experience.
3. **Local-only / privacy-respecting** — no plugin that phones home with vault contents.
4. **Doesn't conflict with Bases** — Bases is the chosen view engine; plugins that double up (Dataview-as-database) need a clear reason to coexist.
5. **HTBAH-compatible, not D&D-locked** — Niklas plays HTBAH (d100, freely-defined skills). Plugins hardcoded to d20 mechanics are a poor fit.
6. **Permissive license** (MIT or similar) — Grimoire is OSS.
7. **Works without configuration** — for v1, plugin pre-configured in `.obsidian/` and "just works" matters more than max features.

**Things this doc does NOT decide:**

- Exact CSS / styling — separate aesthetic concern
- AGENTS.md / agent workflow plugins — covered separately in the integrations brainstorm
- Mobile-specific plugins — Grimoire is GM-tool-on-desktop

## The 2026 Obsidian TTRPG ecosystem

**The Javalent stack is the canonical TTRPG plugin family.** Jeremy Valentine (Javalent / Obsidian-TTRPG-Community) maintains an integrated set: Dice Roller, Fantasy Statblocks, Initiative Tracker, Leaflet, Calendarium, Admonitions, Markdown Attributes. They're designed to interlock — adopting one nudges the others toward becoming the easy choice.

**The other major ecosystem player is RPG Manager** — a system-agnostic campaign management plugin that overlaps significantly with what Grimoire itself does (structured notes for adventures, NPCs, locations, events with relationships). **Not recommended for Grimoire because of the overlap** — Grimoire's value proposition would shrink to "RPG Manager with my preferred folder layout." We're solving the same problem differently.

**Audio/soundboard ecosystem is fragmented.** Several plugins compete: TTRPG Tools: Soundboard, RPG Audio, AlyceOsbourne's Soundboard, Jareika's TTRPG Soundboard, Syrinscape integration. No clear winner; pick by behavioral fit.

**AI/chat ecosystem is dominated by Copilot for Obsidian** ([logancyang/obsidian-copilot](https://github.com/logancyang/obsidian-copilot)) — supports Ollama, OpenAI, Anthropic, Google, LM Studio. Privacy-respecting when configured against local models. The natural pick when AI lands in scope.

**Bases (core) vs Dataview (community):** as of mid-2026, Bases is the official Obsidian-Team initiative, renders instantly in 50k+ note vaults, supports visual filter/sort UI, and is interactive (inline editing). Dataview is "great for reports, terrible for performance and interactivity." **Bases is the bet.** Dataview kept as a fallback for niche cases (task aggregation specifically isn't yet in Bases).

## Plugin categories

### 1. Dice Roller — REQUIRED FOR EARLIEST LOVABLE

**Use case:** roll dice inline in notes (`d10`, `d100`, multi-die expressions). HTBAH uses d100 for skill checks and d10-based weapon damage.

**Candidates:**

| Plugin | Maintainer | Pros | Cons |
|---|---|---|---|
| **Dice Roller** ([javalent/dice-roller](https://github.com/javalent/dice-roller)) | Javalent | Inline dice via `dice:` code block, full expression parser (+, -, ×, ÷, exponents), clickable to re-roll, lookup table support, integrates with Initiative Tracker | Code-block syntax (not inline `[[d20]]`-style) takes a turn to learn |
| **RPG Dice Roller** | community | d20 grammar (advantage/disadvantage, exploding dice), button UI for common dice | D&D-centric grammar; less natural for d100 HTBAH |
| **Obsidian Dice Roller** (rune-bk fork) | community | Lighter weight | Less active maintenance |

**Recommendation: Dice Roller (Javalent).** Most active, broadest expression support, ecosystem integration with Initiative Tracker. The code-block syntax actually works well for HTBAH-style structured stats. Pre-install and pre-configure in `.obsidian/` at Earliest Lovable.

### 2. Audio / Soundboard — REQUIRED FOR EARLIEST LOVABLE

**Use case:** ambient music, scene-specific soundscapes, sound effects (door creak, gunshot, etc.) playable during live sessions.

**Candidates:**

| Plugin | Maintainer | Approach | Notes |
|---|---|---|---|
| **TTRPG Tools: Soundboard** ([community: ttrpg-soundboard](https://community.obsidian.md/plugins/ttrpg-soundboard)) | community | Folder-based library, grid tiles or list view, **Ambience folder auto-loops with separate volume slider**, multi-sound simultaneous playback | Strong fit. Folder convention matches Grimoire's `assets/soundboards/` and `assets/audio/ambient/` |
| **RPG Audio** ([knorrli/obsidian-rpg-audio](https://github.com/knorrli/obsidian-rpg-audio)) | community | Inline note players, sidebar grouped by type, crossfade, **layered audio** (ambience + music + SFX simultaneously) | Strong fit. Inline players in scene/session-prep notes match Grimoire's workflow |
| **Syrinscape Integration** ([scooper4711](https://github.com/scooper4711/obsidian-syrinscape)) | community | Wraps the Syrinscape commercial service | Strong audio quality but requires Syrinscape subscription. NOT local-first. Skip. |
| **Soundboard** (AlyceOsbourne) | community | Inline soundboard in notes | Simpler than the above, but less feature-rich |
| **TTRPG Soundboard** (Jareika) | community | Use Obsidian as a session soundboard | Less actively maintained |

**Recommendation: RPG Audio + (optionally) TTRPG Tools: Soundboard.** RPG Audio's inline note players and layered audio is the killer feature for scene-aware playback ("when the players enter the bar, the bar music starts in the scene note"). TTRPG Tools: Soundboard is the alternative for GMs who prefer a separate soundboard panel over inline players. Pre-install RPG Audio at Earliest Lovable; mention TTRPG Tools: Soundboard as an alternative in the docs.

### 3. Maps / Leaflet — OPTIONAL FOR EARLIEST LOVABLE, FOG OF WAR DEFERRED

**Use case:** interactive battlemaps with creature markers, optional fog of war for exploration reveal.

**Candidates:**

| Plugin | Status | Notes |
|---|---|---|
| **Obsidian Leaflet** ([javalent/obsidian-leaflet](https://github.com/javalent/obsidian-leaflet)) | Active, Javalent | Interactive maps via Leaflet.js, custom battlemaps, markers from Fantasy Statblocks creatures, syncs with Initiative Tracker combat state | Integrates with the rest of the Javalent stack — strong reason to pick this |
| **TTRPG Tools: Maps** | newer | Mentioned in some 2026 reviews as a more powerful alternative | Less well-documented; recommend monitoring rather than adopting |

**Fog of war specifically:** not a built-in feature of Obsidian Leaflet. Leaflet.js itself has plugins like `Leaflet.Mask` that could mask areas, but they're not integrated into the Obsidian plugin. **Fog of war stays deferred** per the existing design — FoundryVTT territory.

**Recommendation: Obsidian Leaflet** for static battlemaps + creature markers when Initiative Tracker is in use. Pre-install at Earliest Lovable. Fog of war remains in the future scope.

### 4. Initiative Tracker — REQUIRED FOR EARLIEST LOVABLE

**Use case:** combat turn order, HP/AC/status tracking during fights.

**Candidates:**

| Plugin | Maintainer | Pros | Cons |
|---|---|---|---|
| **Initiative Tracker** ([javalent/initiative-tracker](https://github.com/javalent/initiative-tracker)) | Javalent | Code-block-driven (` ```encounter `), creatures from Fantasy Statblocks or names + dice rolls, multi-encounter per note, auto-save, syncs with Leaflet maps | D&D-tuned defaults but configurable |
| **Generic Initiative Tracker** | community fork | Simpler, less integrated | Lower ceiling |

**HTBAH compatibility check:** HTBAH uses `1d10 + Handeln` for initiative. Dice Roller can express this; Initiative Tracker accepts dice expressions per-creature. Should work cleanly. **Confirm during integration that the encounter code block accepts d10-only initiative rolls (no d20 assumption).**

**Recommendation: Initiative Tracker (Javalent).** Pre-install at Earliest Lovable, pre-configure to use d10 initiative in HTBAH mode.

### 5. Fantasy Statblocks — RECOMMENDED FOR HTBAH, REQUIRED FOR D&D PRESET (FUTURE)

**Use case:** structured NPC/creature stat blocks. D&D-tuned by default, supports other systems (Pathfinder 2e, The One Ring 2e, 13th Age).

**HTBAH question:** does Fantasy Statblocks support HTBAH-style stats (Begabungen + freely-defined Fähigkeiten)? The plugin is extensible — you can define custom layouts. But the out-of-the-box experience is D&D-tuned. **For HTBAH, a custom statblock layout is required.**

**Recommendation for HTBAH (v1):** ship a sample HTBAH statblock layout file in `mechanics/` if `ruleset=htbah` and `project_type=ttrpg`. Optional to install Fantasy Statblocks. **Without it, NPC stats live in the `character.md` body** (which is the current design anyway). With it, structured statblocks become an option but aren't required.

**Recommendation for D&D preset (future):** Fantasy Statblocks becomes core, with the D&D 5e SRD layout pre-configured.

### 6. Templater — DEFERRED (Static Templates Are Enough For v1)

**Use case:** conditional logic in templates ("if NPC, show How-to-Play section; else hide"), date-aware defaults, dynamic content insertion.

**Pros:** powerful, can clean up the "delete this section if PC" pattern with conditionals.

**Cons:** introduces JavaScript syntax in templates, expands the learning surface, makes templates harder to read.

**Counter-argument:** the current "delete the irrelevant section" pattern works (we settled this in [open-question #13](./open-questions.md)). Static templates with "delete-on-condition" instructions are fine for a v1 vault.

**Recommendation: NOT pre-installed for v1.** GMs who want Templater can install it themselves. Reconsider in Earliest Lovable if real friction emerges from the static-templates approach.

### 7. AI Chat / Vault Embeddings — DEFERRED (FUTURE)

**Use case:** "Which NPCs are tied to the Nightfall faction?" "Are there contradictions in the timeline of the last 3 sessions?" Generated suggestions for encounter design, NPC dialogue.

**Candidate: Copilot for Obsidian** ([logancyang/obsidian-copilot](https://github.com/logancyang/obsidian-copilot)) — supports Ollama, OpenAI, Anthropic, Google, LM Studio. Optional embeddings via local models (`nomic-embed-text`). Configurable to point at `qube.local:11434` for local-only AI on Niklas's setup.

**Strong fit when AI lands in scope**, but deferred. The "Future" tier explicitly lists AI chat as deferred until campaign content matures.

**Recommendation: DEFERRED.** Document in design as the canonical choice when AI tier ships.

### 8. Timeline — DEFERRED, OPTIONAL FOR EARLIEST LOVABLE

**Use case:** chronology visualization — when worldbuilding has many historical events, or campaign sessions accumulate, a visual timeline helps maintain consistency.

**Candidates:**

| Plugin | Maintainer | Notes |
|---|---|---|
| **Chronos Timeline** ([clairefro/obsidian-plugin-chronos](https://github.com/clairefro/obsidian-plugin-chronos)) | community | Markdown-driven, year-to-second granularity, AI-assisted timeline generation from highlighted text | Active and modern |
| **April's Automatic Timelines** ([April-Gras](https://github.com/April-Gras/obsidian-auto-timelines)) | community | Tag-driven, designed for storytelling/worldbuilding, flexible date formats | TTRPG-focused per the tutorial site |
| **Chronology** | community | Sidebar calendar view of notes by creation/modification date | Different use case (note dates, not in-world dates) |
| **Easy Timeline** | community | Simple block syntax | Less feature-rich |

**Recommendation for Grimoire v1: NOT pre-installed.** Worldbuilding chronology is useful but not required for the first sessions. If a campaign accumulates enough lore that chronology becomes essential, the GM can install April's Automatic Timelines (the more TTRPG-focused option). Document as a "recommended add-on" for Earliest Lovable.

### 9. Dataview — KEEP AS FALLBACK ONLY

**Use case:** complex queries Bases can't express (task aggregation specifically).

**Performance reality:** Dataview can seriously degrade vault performance, especially on mobile and at scale. Bases is faster and renders instantly even in 50k+ note vaults.

**Recommendation: NOT pre-installed.** If a specific Grimoire view fails Bases' expressiveness and Dataview is the only path, document the gap and install Dataview as a targeted fallback. Don't bake it in by default.

### 10. Calendarium (Javalent) — OPTIONAL, INTERESTING FOR HOLOGRAMMATICA

**Use case:** custom in-world calendars for fictional universes with non-Earth date systems. Lets you track "day 17 of the 3rd cycle of the Ash Calendar" alongside Earth-style dates.

**Fit for Grimoire:** strong for high-fantasy or alien sci-fi campaigns. Less relevant for noir or near-future cyberpunk that uses Earth calendars.

**Recommendation for v1: NOT pre-installed,** but document as a "consider this if your campaign uses a custom calendar" plugin. Hologrammatica (near-future cyberpunk) doesn't need it.

### 11. Admonitions (Javalent) — REDUNDANT WITH CORE CALLOUTS

**Use case:** custom callout styles beyond the built-in Obsidian callouts.

**Obsidian core callouts** already support `[!warning]`, `[!tip]`, `[!info]`, `[!quote]`, custom `[!infobox]`, etc. Grimoire's design uses these natively.

**Recommendation: NOT pre-installed.** Core callouts cover everything Grimoire needs.

## The v1 Recommended Plugin Set (per project_type)

Grimoire ships pre-configured `.obsidian/` with community plugins varying by `project_type`. All shipped at **Earliest Lovable**; the GM can disable any they don't want.

### TTRPG project_type (full Javalent stack)

| Plugin | Why |
|---|---|
| **Dice Roller** (Javalent) | HTBAH d100 rolls inline; Initiative Tracker integration |
| **Initiative Tracker** (Javalent) | Combat is core to live play; pre-configured for d10 HTBAH initiative |
| **Obsidian Leaflet** (Javalent) | Optional but pre-installed so the `## Map` section in scene/location templates can use it; battlemaps with creature markers |
| **RPG Audio** | Inline note audio players for ambient/music/SFX in scene + session-prep notes |
| **Fantasy Statblocks** (Javalent) | Recommended for D&D-style stats; HTBAH users get a custom layout in `mechanics/` |

**5 community plugins** for TTRPG vaults, all Javalent stack-compatible except RPG Audio.

### Video-game project_type (minimal)

| Plugin | Why |
|---|---|
| Canvas (core) | System diagrams, dependency graphs, faction relationship webs |
| Timeline (optional) | Chronology of the game's narrative or development milestones — install if useful |

No TTRPG-flavored plugins. The video-game vault is design-side; live-play features are irrelevant.

### Generic project_type (core only)

No community plugins pre-configured. Core plugins (Graph View, Backlinks, Canvas, Bases, Templates, Bookmarks, Properties) are enabled by default. User adds community plugins as fits their actual project shape (novel, screenplay, board game, etc.).

**Deferred to Future:**

- Templater (static templates work for v1)
- Copilot for Obsidian (AI tier — wait for the AI chat scope to materialize)
- Chronos Timeline / April's Automatic Timelines (chronology — install if your campaign needs it)
- Calendarium (custom calendars — install if your universe has non-Earth dates)
- Fog of War mapping (FoundryVTT territory)
- Dataview (only as targeted fallback if Bases fails for a specific query)

## Bases Validation

**Bases stays the primary view engine.** Confirmed by the research:

- Renders instantly in 50k+ note vaults; Dataview degrades vault performance, especially on mobile
- Visual filter/sort UI vs Dataview's code-only approach
- Interactive (inline editing) vs Dataview's read-only views
- Official Obsidian-team plugin (now a core plugin)
- "Already good enough to completely replace Dataview for the majority of users"

**Known Bases gap:** task aggregation is not yet in Bases. If Grimoire needs to aggregate `- [ ]` checkboxes across notes (e.g., "show me all incomplete pre-session checklist items across all session-preps"), Dataview would need to be installed as a targeted plugin. **Not a v1 use case.** Note as known limitation.

## What's NOT a Plugin Decision (revisit if it becomes one)

- **CSS snippets** for infobox and genre themes: ship in `.obsidian/snippets/` from the template. These are not plugins.
- **Vault health scripts** (orphan detection, status consistency): bash/Python scripts in `scripts/` on the template repo side. Not plugins.
- **Cross-vault tooling**: e.g., a "global campaigns dashboard" listing all campaigns. Out of Grimoire scope; would be Mikoshi territory (the personal vault) — see [Mikoshi README](../mikoshi/README.md).

## Open Questions

- **Exact Initiative Tracker config for HTBAH d10 initiative.** Verify during Earliest Lovable implementation that the encounter code block accepts custom initiative dice (not d20 hardcoded). If not, add a custom configuration step.
- **RPG Audio integration with Grimoire's `assets/audio/` folder convention.** Does the plugin auto-discover files in subfolders? If yes, the convention is reinforced. If no, configure manually in `.obsidian/`.
- **Custom HTBAH statblock for Fantasy Statblocks.** The plugin is extensible; this is a one-time content creation task that ships with the `mechanics/` content for HTBAH.
- **Plugin update cadence vs Copier update cadence.** When Grimoire's `.obsidian/` config references plugin versions, who's responsible for updating? Document the convention. (Suggestion: pin major versions in the `.obsidian/community-plugins.json`, encourage Obsidian's built-in plugin update flow per-vault.)

## Open Follow-up

- **Watch Obsidian-TTRPG-Community releases.** The org is the canonical TTRPG plugin hub. Refresh this doc every ~6 months or when a major Javalent release lands.
- **Watch Bases evolution.** Bases is young as a core plugin. New features may eliminate some "Dataview as fallback" cases entirely.
- **Test the v1 plugin set against an actual Hologrammatica session-prep.** Before declaring Earliest Lovable shipped, run through one Hologrammatica session with the full plugin set and note any friction.

---

## Sources

- [Obsidian TTRPG Tutorials — The Plugin List](https://obsidianttrpgtutorials.com/Obsidian+TTRPG+Tutorials/Plugin+Tutorials/The+Plugin+List)
- [Obsidian Stats — TTRPG-tagged plugins](https://www.obsidianstats.com/tags/ttrpg)
- [Plugins for TTRPG — Obsidian Hub](https://publish.obsidian.md/hub/02+-+Community+Expansions/02.01+Plugins+by+Category/Plugins+for+TTRPG)
- [Javalent's Plugins for Obsidian](https://plugins.javalent.com/home)
- [Dice Roller GitHub (Javalent)](https://github.com/javalent/dice-roller)
- [Initiative Tracker GitHub (Javalent)](https://github.com/javalent/initiative-tracker)
- [Obsidian Leaflet GitHub (Javalent)](https://github.com/javalent/obsidian-leaflet)
- [Fantasy Statblocks GitHub (Javalent)](https://github.com/javalent/fantasy-statblocks)
- [TTRPG Tools: Soundboard](https://community.obsidian.md/plugins/ttrpg-soundboard)
- [RPG Audio Plugin (knorrli)](https://github.com/knorrli/obsidian-rpg-audio)
- [TTRPG Soundboard (jgradim)](https://github.com/jgradim/obsidian-soundboard)
- [Soundboard (AlyceOsbourne)](https://github.com/AlyceOsbourne/obsidian-soundboard)
- [Copilot for Obsidian (logancyang)](https://github.com/logancyang/obsidian-copilot)
- [Templater (SilentVoid13)](https://github.com/SilentVoid13/Templater)
- [Chronos Timeline (clairefro)](https://github.com/clairefro/obsidian-plugin-chronos)
- [April's Automatic Timelines (April-Gras)](https://github.com/April-Gras/obsidian-auto-timelines)
- [Dataview vs Datacore vs Obsidian Bases (Obsidian Rocks)](https://obsidian.rocks/dataview-vs-datacore-vs-obsidian-bases/)
- [How to Migrate to Obsidian Bases from Dataview](https://practicalpkm.com/moving-to-obsidian-bases-from-dataview/)
- [Awesome Obsidian Community Plugins for D&D (phd20)](https://phd20.com/blog/obsidian-community-plugins-dnd/)
- [Nicole van der Hoeven — interview with Jeremy Valentine (Javalent)](https://nicolevanderhoeven.com/blog/20220409-jeremy-valentine-and-his-obsidian-plugins/)
