# Wiki Presentation Patterns (BG3 Wiki Study)

> A study of the [Baldur's Gate 3 Wiki](https://bg3.wiki/) as a reference for how Grimoire vaults present canon. Two takeaways: an **inline icon-before-link system** (portraits in prose) and a **page-structure grammar** (general → specific, with quest pages mapping cleanly onto Layer 2 session planning). Includes proposed Layer 1 template adaptations.

## Why this doc exists

Niklas flagged the BG3 wiki as a look-and-feel target, specifically (a) the small per-entity icons that sit in front of every inline link to a character / item / spell, and (b) the way the wiki describes characters, locations, and **quests**. The quest structure matters because it's the closest existing analogue to how a Grimoire vault will plan sessions and scenes in Layer 2.

This doc captures what's worth borrowing, the one real design tension in it, and how our existing Layer 1 templates should adapt. It does **not** change any templates yet, it proposes the changes for a decision.

**Scope guardrails (from Niklas):**

- The icon mechanic is a **theming concern**, not a content concern. Note bodies stay clean (`[[astarion]]`, not `{{icon link | ... }}`). The icon must be derived from the note, not typed into the prose.
- The dark + amber BG3 palette is **not** being adopted wholesale. Palette stays per-vault custom (genre CSS). What we want is the *icon system* and the *structural grammar*, not BG3's specific colours.
- Per-entity **raster portraits** (each note shows its own image), not one generic glyph per type.

## What BG3 actually is

MediaWiki with a heavily customised theme. The screenshot Niklas shared is its **dark mode** (charcoal background, warm amber link accent). The inline icons are produced by a template, **`{{icon link}}`**:

```
{{icon link | Astarion Icon.png | Astarion }}
{{icon link | size=20 | Pixie Icon.png | Pixie }}
```

Param 1 = icon file, param 2 = link target, optional param 3 = display text. Default size 25×25px; their own guidance is **16–24px inline** (taller icons wreck line spacing). Note the consequence: **BG3's per-entity portraits work precisely because the icon is named in the wikitext.** The icon lives in content. That is exactly the thing we said we *don't* want, which is the core tension below.

Their [style manual](https://bg3.wiki/wiki/Help:Style_manual) is worth stealing as policy:

- Inline icons (≤20px) for **characters, items, spells, conditions, passive features**. ✅
- **No** inline icons for core concepts (abilities, classes, races, skills) or in section headers. ❌
- "Less is more." Avoid icon-dense paragraphs.
- Colours defined via **CSS classes, never inline styles.**

---

## 1. The inline icon system (the headline feature)

### The tension to resolve

Two requirements pull against each other:

1. **Pure theming** — content stays `[[astarion]]`, no icon named in prose.
2. **Per-entity raster portraits** — each note shows its own image, BG3-style.

BG3 satisfies #2 by violating #1. We want both. The option space we evaluated:

| Approach | Per-entity raster portrait | Pure theming (clean content) | No plugin | Cost / caveat |
|---|---|---|---|---|
| **Iconize plugin** (DECIDED) | ✅ via SVG-wrapped raster | ✅ | ❌ community dep | Inline "icons in links" is a built-in toggle; raster needs SVG wrapping; first community plugin Grimoire ships |
| Generated CSS snippet | ✅ (base64 data URIs) | ✅ | ✅ | Fragile `data-href` matching + unverified `url()`/render gates; we'd own the generator. **Kept as fallback** if Iconize render fails |
| Pure hand-written CSS | ❌ one glyph per *type* only | ✅ | ✅ | CSS can't read a *target* note's frontmatter |
| Manual inline embed (`![[ox.png\|18]] [[ox]]`) | ✅ | ❌ icon in content | ✅ | Tedious, clutters source, this is the BG3 model |

**Decision (2026-06-21): adopt Iconize.** It ships an "icons in links" toggle that renders the icon assigned to a note inline before every link to that note, exactly the BG3 mechanic, and robustly across Live Preview and Reading view. That removes the fragile, self-owned parts of the CSS approach (`data-href` matching, `url()` sandboxing, dual-view rendering). Iconize's one limitation is that custom icons are SVG/font/emoji only, no raster, so portraits are fed in as **SVG files that wrap a base64 raster** (`<image href="data:...">`). The generated-CSS approach is retained only as a documented fallback if SVG-wrapped rasters don't render inline.

**Why pure CSS alone can't do it:** Obsidian renders an internal link as `<a class="internal-link" data-href="astarion">`. CSS can match `data-href` and inject a `::before` image, but it cannot look up *that target note's* frontmatter to find which image. So hand-written CSS can only give "all characters share one glyph," not per-entity portraits, which is also why the type-glyph fallback below *is* pure-CSS-cheap while portraits are not.

### The chosen design: three stacked layers

The two ambitions (every link iconified vs. real per-entity faces) stack instead of competing:

1. **`portrait` frontmatter property** — source image, drives a Bases **card view** (gallery) and is the source for portrait icons. Zero plugin, zero risk. *(Shipped.)*
2. **Default layer: per-type glyphs** — a per-type `icon` frontmatter default shipped in each template (`character` → `LiUser`, `location` → `LiMapPin`, `item` → `LiGem`, `faction` → `LiFlag`, `lore` → `LiScroll`), rendered by Iconize's *icons-in-links*. Note: Iconize **custom rules can't reliably match on a `type` frontmatter** (rules are filename/path-regex), and `world/` is flat, so the per-note `icon` default in the template is the dependable channel, not a rule. Every link gets *an* icon immediately, and this is the **permanent graceful fallback** for any entity that has no portrait art yet. *(Shipped.)*
3. **Override layer: per-entity portraits** — a generator turns each note's `portrait` into an SVG-wrapped raster icon and rewrites that note's `icon` value to it, overriding the type glyph. BG3-exact, *where art exists*. *(Next.)*

Net behavior: an entity with art shows its face; one without shows its type glyph; no link is ever icon-less.

### Why the `portrait` property earns its place (corrected rationale)

The earlier draft called this property "the single source of truth for the infobox and the CSS." That was wrong: **Obsidian markdown can't render a frontmatter value as an image embed without a plugin**, so the infobox still needs its literal body embed (`> ![[character-name.png]]`). The property is therefore a *second* declaration, not a unifying one.

It still earns its place, for a different reason: **Bases**. A card/gallery view can only render an image from a frontmatter property, never from a body embed. That independent benefit (plus being the source the portrait generator reads) justifies the one-filename duplication, which `lint-canon` can later check stays in sync.

```yaml
portrait: "[[character-name.png]]"   # optional/nullable; matches the infobox embed
```

### Sequencing (decided 2026-06-21)

**Glyphs + cards now, portraits next.** Layers 1–2 shipped (guaranteed to work). Layer 3 is prototyped separately to de-risk the one open gate before committing it.

### Plugin-shipping decision (decided 2026-06-24)

Grimoire shipped zero community plugins before this; Iconize is the first, so this sets the precedent. **Chosen: config + documented install** (not vendoring the plugin binary). What ships in the template:

- `.obsidian/community-plugins.json` lists `obsidian-icon-folder` (so it auto-enables once installed).
- `.obsidian/plugins/obsidian-icon-folder/data.json` pre-seeds the settings we depend on: `iconInFrontmatterEnabled: true` (the only non-default), plus `iconsInLinksEnabled`, `iconsInNotesEnabled`, `lucideIconPackType: native`, field name `icon`.
- Per-type `icon` defaults in the five entity templates.
- A one-line README step: turn off Restricted Mode → Browse → install Iconize → Enable.

**No icon pack is bundled.** Iconize uses Obsidian's **native Lucide** (`lucideIconPackType: native`, the plugin default), prefix `Li`, icon id = `Li` + PascalCase of the Lucide name (`map-pin` → `LiMapPin`). This sidesteps shipping pack zips entirely. Verified against Iconize `src/settings/data.ts` and `src/icon-pack-manager/` at v2.14.7.

### Open questions (icon system)

- **SVG-wrapped raster render (the gate).** Does Iconize render an SVG whose content is an embedded base64 raster, inline in links, in both Live Preview and Reading view? Blocks layer 3 only. Prototype before building the generator.
- **Agent-created notes need `icon` + `portrait` too.** The template covers human-created notes (Ctrl/Cmd+T), but the primary workflow is `/ingest-source`, which writes notes directly. The grimoire-overlay skill / ingest-source command must set `icon` (per type) and `portrait` on generated entities, else agent-built vaults get no glyphs. **Clear next follow-up.**
- **Pre-seeded `data.json` merge.** Confirm Obsidian/Iconize loads our pre-seeded `data.json` on first install rather than overwriting it with defaults (standard `Object.assign(DEFAULT, loadData())` suggests yes; verify on first open).
- **Portrait shape.** Circular for `type: character`, slightly-rounded/square for items/locations, mirroring BG3. The generator branches on `type`.
- **Retina / sizing.** Document a recommended portrait source size (~2× the rendered icon).

---

## 2. Page-structure grammar (general → specific)

Every BG3 entity page runs **infobox → prose → mechanics → exhaustive cross-linked detail**. Observed anatomy:

- **Character** (Astarion): infobox (identity + stats) → Overview (role, recruitment) → Description (Appearance, Personality) → Gameplay → History → **Involvement (act-by-act arc + branching endings)** → Interactions & Scenes → Loot.
- **Location** (Emerald Grove): **breadcrumb** (`Forest ← Emerald Grove → Secluded Cove`) → Overview → History → sub-locations → **Related Quests** → Characters (grouped by faction) → Loot → Gallery → Notes.
- **Quest** (Rescue the Grand Duke): Objectives → **Walkthrough split into location-keyed beats, each with branching approaches and consequences that ripple into later acts** → Quest Rewards → Notes → Bugs.

### The quest structure is the Layer 2 prize

BG3's quest anatomy is, structurally, a GM's session plan:

| BG3 quest element | Grimoire Layer 2 equivalent |
|---|---|
| Quest (objectives, overall arc) | `session-prep` / a quest-or-arc note |
| Walkthrough beat (per location) | a `scene` (already has `location` as a wikilink list) |
| Branching approaches ("front door vs side") | scene prep: anticipated player paths |
| Consequences rippling forward | scene/quest outcomes feeding `status` + downstream scenes |
| Cross-links to NPCs / places / quests | native wikilinks |

The lift for Layer 2: scenes/quests want **explicit objectives** and a **consequences/outcomes** section, not just a flat description. The act-by-act "Involvement" pattern on character pages is a good model for how a recurring NPC threads across sessions, but see the DRY note below before making it a static section.

---

## 3. Proposed Layer 1 template adaptations

Two cross-cutting moves, then per-template specifics. Style-manual restraint applies throughout: **add structure only where it earns its place.** We are not turning lean templates into BG3's exhaustive stat tables, our design principle is "lean frontmatter + body sections," and the BG3 study *validates* keeping the infobox lean with the portrait on top.

### Cross-cutting

1. **Add a `portrait` property** to every entity template (character, location, item, faction, lore). Optional/nullable. Drives the Bases card view (gallery) and the portrait icon generator. The infobox keeps its literal body embed (markdown can't render a frontmatter image without a plugin), so the property is a parallel declaration, see §1. **[DONE]**
2. **Prefer dynamic over hand-maintained lists.** BG3 *hand-curates* "Characters in this location" and "Related quests." Grimoire should **generate these from wikilinks via Bases embeds**, not static prose. This is the native translation of BG3's curated sections, and it stays DRY: a character's `found-at` / `faction` already encodes the relationship, so a location's "Characters here" and a faction's "Members" should be Bases views, not lists a human keeps in sync.

### Per template

| Template | Current body sections | Proposed change | Why |
|---|---|---|---|
| **character** | Description, Background, Relationships, GM Secrets, Notes | Add `portrait`. Optionally split Description → **Appearance** (what players see) + **Personality / Motivation**. Do **not** add a static "Involvement/Appearances" section. | Appearance-vs-motivation split mirrors BG3 and is genuinely useful at the table (read-aloud vs play guidance). An NPC's appearances across scenes should come from **backlinks**, not a hand-kept list. |
| **location** | Description, Atmosphere, Notable Features, Connections, GM Secrets, Notes | Add `portrait`. Keep `parent-location`/`district` (already the BG3 breadcrumb). Make "Connections" / a new "Here" area a **Bases embed** (scenes where `location` contains this; characters with `found-at` here). "Notable Features" already covers BG3's points-of-interest. | Location pages are natural hubs; the BG3 "Related Quests" + "Characters" sections become live queries instead of stale lists. |
| **item** | Description, History, Mechanics, GM Secrets, Notes | Add `portrait`. No structural change. | Already aligns with BG3 item anatomy; `held-by`/`found-at` cover provenance. |
| **faction** | Description, Goals, Members, Relationships, GM Secrets, Notes | Add `portrait` (emblem/sigil). Turn **Members** into a **Bases embed** (characters where `faction` contains this). | Membership is already encoded on characters; a static member list double-maintains it. |
| **lore** | Description, Significance, Connections, GM Secrets, Notes | Add `portrait` (**optional** — lore often has no image; CSS generator skips when absent). No other change. | Lore is the type least likely to carry a portrait; graceful no-icon fallback matters here. |

### Forward pointer: Layer 2 (scene / quest)

Out of scope for the Layer 1 adaptation, but the quest study (§2) should drive the Layer 2 templates when they're built. The current `scene.md` is Setup / Action / Resolution; BG3 argues for adding **Objectives** and **Consequences/Outcomes**, and for a quest-or-arc note that aggregates location-keyed scene beats. Fold this into [scene-composition.md](./scene-composition.md) and the Layer 2 roadmap work rather than acting on it now.

## Appendix: BG3 example pages by type

One representative page per BG3 page type, mapped to the Grimoire type it informs. The structure column is the section order (general → specific) as observed.

| BG3 page type | Example | Section order | Grimoire type |
|---|---|---|---|
| **Character** | [Astarion](https://bg3.wiki/wiki/Astarion) | infobox (identity + stats) → Overview → Description (Appearance / Personality) → Gameplay → History → Involvement (act-by-act) → Interactions & Scenes → Loot | `character` |
| **Location** | [Emerald Grove](https://bg3.wiki/wiki/Emerald_Grove) | breadcrumb → Overview → History → sub-locations → Related Quests → Characters (by faction) → Loot → Gallery → Notes | `location` |
| **Item / weapon** | [Phalar Aluve](https://bg3.wiki/wiki/Phalar_Aluve) | inscription/lore header → Properties → Special → Weapon Actions → **Where to Find** → Notes → Gallery | `item` |
| **Spell / action** | [Fireball](https://bg3.wiki/wiki/Fireball) | Description → Properties (cost/damage/range/AoE) → At higher levels → **How to learn** (Classes / Items / Other) → Notes → Visuals | `mechanics` (no `spell` type) |
| **Condition / status** | [Burning](https://bg3.wiki/wiki/Burning) | infobox (effect / removal / immunity) → Properties → Notes → **Sources of Burning** → Creatures with Burning → same-stack comparison table | `mechanics` |
| **Faction / group** | [Cult of the Absolute](https://bg3.wiki/wiki/Cult_of_the_Absolute) | banner (no infobox) → Involvement (by act) → Members (by hierarchy) → Related items → Related literature → Related quests → Quotes → See also | `faction` |
| **Lore / race** | [Githyanki](https://bg3.wiki/wiki/Githyanki) | in-game quote → About → Racial Features → Religion → Equipment → **Notable Githyanki** (cross-ref) → See Also → References | `lore` |
| **Quest** | [Rescue the Grand Duke](https://bg3.wiki/wiki/Rescue_the_Grand_Duke) | Objectives → Walkthrough (location beats → branches → consequences) → Rewards → Notes → Bugs | Layer 2 (`scene` / `session-prep`) |

### Patterns these reveal (beyond §2)

- **Provenance is a universal section, and it's always relational.** "Where to Find" (item), "How to learn" (spell), "Sources of Burning" (condition), "Notable Githyanki" (lore) are the same move: *what connects to this thing*. Grimoire already encodes provenance as properties (`found-at`, `held-by`, `source`, `faction`), so these should be **Bases-driven**, not hand-written, reinforcing cross-cutting move #2 in §3.
- **The icon system must extend to `mechanics/`, not just Layer 1.** Spells, actions, and conditions are exactly the inline types BG3's style manual says *should* carry icons. In Grimoire those live in Layer 2b (`mechanics/`), so the `portrait` property and the generated CSS need to cover mechanics notes too, not only `world/` entities. Carry this into the icon-system design.
- **Faction pages have no infobox** (banner + symbol instead), and members are grouped by hierarchy/reveal-state, not flat roles. Validates making faction Members a dynamic Bases list (§3) and keeping the faction infobox optional/lean.
- **"Notable X" / "Characters here" lists are everywhere and always cross-references.** Every hub-type page (location, faction, lore) curates a list of related entities by hand. That's the single biggest manual-maintenance cost on the BG3 wiki, and the single clearest win for Grimoire's wikilink + Bases model: generate them.

## Open questions

- **Icon system** — see §1 (regen trigger, `data-href` stability, portrait shape per type, retina sizing, reading-vs-edit view). All need a prototype pass before committing.
- **`portrait` vs reusing the infobox image** — is one source-of-truth property worth the migration from the current hardcoded `![[name.png]]`? (Lean says yes: it unlocks the icon feature and stays queryable.)
- **Appearance/Personality split** — genuinely useful, or scope creep against "less is more"? Decide per the validation campaigns.
- **Bases embed ergonomics** — confirm Bases can express "characters where `faction` list contains this note" cleanly enough to replace hand-kept Members/Characters lists.

## Sources

- [Baldur's Gate 3 Wiki](https://bg3.wiki/)
- [Template:Icon link](https://bg3.wiki/wiki/Template:Icon_link)
- [Help:Style manual](https://bg3.wiki/wiki/Help:Style_manual)
- [Astarion (character page)](https://bg3.wiki/wiki/Astarion)
- [Emerald Grove (location page)](https://bg3.wiki/wiki/Emerald_Grove)
- [Phalar Aluve (item / weapon page)](https://bg3.wiki/wiki/Phalar_Aluve)
- [Fireball (spell page)](https://bg3.wiki/wiki/Fireball)
- [Cult of the Absolute (faction page)](https://bg3.wiki/wiki/Cult_of_the_Absolute)
- [Burning (condition page)](https://bg3.wiki/wiki/Burning)
- [Githyanki (lore / race page)](https://bg3.wiki/wiki/Githyanki)
- [Rescue the Grand Duke (quest page)](https://bg3.wiki/wiki/Rescue_the_Grand_Duke)
- [Obsidian Iconize — frontmatter docs](https://florianwoelki.github.io/obsidian-iconize/files-and-folders/use-frontmatter.html)
