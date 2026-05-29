# 📜 Grimoire — Brainstorm: Scene & Session Composition (Layer 2)

> Design notes for the Layer 2 creative skill(s) that turn canon + creative intent into table-ready scenes and sessions. Captured after validating an early version against Hologrammatica (chapters 1–2 ingested, first scene composed in German). Not yet built; this file collects the design constraints.

## Status

Pre-implementation. Validated empirically via a manual run on Hologrammatica Ch. 1. Findings below feed into the eventual `compose-scene` / `compose-session` skills.

## Naming (working)

- `compose-scene` — produces a single scene note (and optional `.canvas` visualization, optional handout(s))
- `compose-session` — bundles 2–5 scenes into a session, picks pacing, surfaces prep needs

Both are Layer 2 siblings to Layer 1's `ingest-source`. Plural `compose-*` to disambiguate from `scene.md` the template.

## Two modes

The skill must handle both authoring paths:

1. **Adaptation mode.** Vault has `sources/` with ingested chapters. Scene draws from existing canon + source events. Skill needs to identify "what slice of the source becomes one good scene." This is what we tested.
2. **Original mode.** No `sources/`, or sources are silent on what the scene should be. Skill brainstorms with the user — proposes 2–3 scene concepts that fit the canon and current story arcs, picks one with the user, then composes.

Detect mode automatically (presence of relevant `sources/` + project_mode), but always allow override.

## What makes a scene well-scoped

The hardest part. A scene should:

- **Start at a moment of arrival or invitation** (someone walks in, a door opens, a message arrives). Not mid-routine.
- **End at a decision point or transition** (accept/refuse, leave for next location, learn the next vector). Not after the consequences play out.
- **Contain exactly one "load."** One case is handed over, one revelation lands, one confrontation happens. If two loads exist, it's probably two scenes.
- **Have a forced-choice moment** for the players. Smalltalk + exposition + Mumeishi-pitch is one scene because Mumeishi's exit forces "do we take this?"

When scoping from sources, look for natural beat-changes in the prose: viewpoint shifts, scene breaks, "ich kehre in mein Apartment zurück" type sentences. Cut there.

## Scene note shape (validated)

Single scene note in `story/`, kebab-case filename, German-or-English per project. Sections in this order, kept compact:

1. **Infobox** — location, time, NPCs present, linked handouts.
2. **Was die Szene leisten muss** / "What the scene must deliver" — 3–5 bullets. The success check.
3. **Intro (vorlesen)** — a single boxed read-aloud paragraph. **Mandatory.** Sensory (sight, sound, smell), one strong cinematic image (the door creaks, the sax stops mid-phrase, the holo flickers at the window). One opening line of dialogue.
4. **Beats table** — 4–6 rows, one beat per row, each row has "what happens" + "what you (GM) need to do." Table form, not prose.
5. **Voice-Cheat** — 2-column table of NPCs with energy/tone/tic/never. Plus 3–5 sample phrases per NPC. Phrases in quotes, ready to read.
6. **Was riecht komisch / What's off** — 3–5 bullets for attentive players. Friction handles, not solutions.
7. **Wenn jemand ablehnt / Refusal branch** — 3 bullets covering "one refuses / all refuse / one accepts." Every scene with a forced choice needs this.
8. **Anschluss / Hooks out** — 2–4 vectors for what comes next, each with the canon entities the players have to interact with.
9. **GM-only worldbuilding-pflichtbeats** — collapsed callout. Checklist of canon / tone beats that must land in this scene (e.g., "show one hologram in action", "drop the word 'Milchtüte' once"). This is how Layer 2 stays accountable to Layer 1.

### The verbose-trap

The first auto-generated draft will be too verbose. Bias the skill toward:

- Tables over paragraphs.
- Quoted phrases over described tone.
- Bullets over essays.
- One Intro paragraph that's vivid; everything else is a GM cue card.

GM should be able to run the scene from the note alone, scrolling once.

## Optional companions

- **`.canvas` file** — same name as the scene note, visualizes the beat flow + side info (voice, refusal, what's off, anschluss vectors) + file-links to canon entities. We validated this. Useful as a GM dashboard during play.
- **Handout(s)** in `play/` — in-world documents (case files, letters, dossiers). Frontmatter `for-scene: [[scene-name]]`. Generated only when the scene's pitch involves an artifact handed to the players.

## NPC voice generation

The voice work is half the value of the scene note. Rules learned:

- Pull from existing character notes (Description / Background sections). Quotes already in canon (e.g., Galahad's "Bengalen-Gene", his father's lawyer joke) become sample phrases.
- Generate phrases in **the project's language** (German for Hologrammatica). Don't translate canon dialogue.
- Per NPC: energy, tonfall, one physical tic, one thing they never do/say. Compact 2-column tables for two NPCs.
- 3–5 ready-to-speak phrases per NPC, in quotes, with brief stage directions where useful.

## Sessions

A session is 2–5 scenes that share location-cluster or arc. `compose-session` should:

- Pick scenes that form a satisfying pacing curve (open → middle complication → choice/cliffhanger).
- Surface prep needs that span scenes (one prepped handout, one piece of music, etc.).
- Produce a `session-prep` note linking the composed scenes.

Out of scope for the first version of `compose-scene`. Build single-scene first.

## Open questions

- **When the source contradicts the scene we want to compose.** Adaptation mode: do we flag conflict and ask? Probably yes — surface like `ingest-source` does, never overwrite quietly.
- **Multi-language handling.** Detect from `home.md` / project content? Or ask once per skill invocation?
- **Replayability / variants.** If the user composes scene 01 twice (different framings), do we version? Probably: append `-v2` or branch off `canon: false`. Defer.
- **Player-facing vs GM-facing.** Currently everything is GM-facing. Player handouts use the `[!warning]` / `[!tip]` callout layers and `status: revealed` filtering — but we may want a `--player-export` flag that strips GM blocks and emits an Anki-card-style or single-page handout for the table.

## Why this matters

Layer 1 makes the vault a real worldbuilding tool. Layer 2 makes it a real *creative* tool. The scene is the unit where canon stops being a reference and starts being a thing the user *does at the table*. If `compose-scene` produces notes a GM can run from cold, Grimoire crosses from "organized wiki" to "operational GM rig." That's the layer-2 thesis.

## Backlinks

- See [features.md](features.md#narrative-work-story) — Layer 2 narrative work feature catalog
- See [roadmap.md](../roadmap.md) — Layer 2 scene workflow item
- See [ingest-source-summaries](features.md#source-material) — Layer 1 source summaries (the read-side counterpart this skill consumes)
