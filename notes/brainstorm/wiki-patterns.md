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

BG3 satisfies #2 by violating #1. We need both. Here's the option space:

| Approach | Per-entity raster portrait | Pure theming (clean content) | No plugin | Cost / caveat |
|---|---|---|---|---|
| **Generated CSS snippet** (recommended) | ✅ | ✅ | ✅ | Needs a regeneration step when portraits change |
| Iconize plugin | ❌ SVG/font only (PNG must be converted) | ✅ | ❌ community dep | Raster portraits unsupported; inline-link feature unconfirmed |
| Pure hand-written CSS | ❌ one glyph per *type* only | ✅ | ✅ | CSS can't read a *target* note's frontmatter |
| Manual inline embed (`![[ox.png\|18]] [[ox]]`) | ✅ | ❌ icon in content | ✅ | Tedious, clutters source, this is the BG3 model |

**Why pure CSS alone can't do it:** Obsidian renders an internal link as `<a class="internal-link" data-href="astarion">`. CSS can match `data-href` and inject a `::before` image, but it cannot look up *that target note's* frontmatter to find which image. So hand-written CSS can only give "all characters share one glyph," not per-entity portraits.

### Recommendation: generated CSS snippet

A Grimoire command scans notes carrying a `portrait` property and emits a snippet into `.obsidian/snippets/portrait-icons.css`:

```css
a.internal-link[data-href="astarion"]::before {
  content: "";
  display: inline-block;
  width: 18px; height: 18px;
  margin-right: 0.25em;
  background-image: url("assets/images/characters/astarion.png");
  background-size: cover;
  border-radius: 50%;
  vertical-align: text-bottom;
}
/* ...one rule per entity with a portrait... */
```

This is the only approach that satisfies **all four** wants at once: per-entity raster portraits, clean content, no plugin, and it's genuinely theming (a CSS snippet, regenerable, deletable without touching notes).

**Why it fits Grimoire's grain:**

- `research.md` already rules that **CSS snippets are not a plugin decision** and ship in `.obsidian/snippets/`. This slots into a decision already made, it doesn't open a new plugin question.
- Generating artifacts from vault content is the same muscle as `ingest-source`. A `refresh-portraits` command (or a step folded into an existing command) is idiomatic.
- It degrades gracefully: a note without a `portrait` simply gets no icon, the link still works. Pull the snippet and the vault is untouched plain markdown (the portability moat in `research.md`).

**It's tier-3 "custom," but cheaply.** Per the plugin hierarchy, tier 3 needs justification. This isn't a plugin to maintain, it's a generator emitting static CSS, and tiers 1–2 genuinely can't deliver per-entity raster portraits as pure theming. The gap is real and the value (the single feature Niklas pointed at) justifies it.

### The keystone template change: a `portrait` property

The whole system hinges on one frontmatter field. Today the portrait is **hardcoded in the body** (`> ![[character-name.png]]` inside the infobox callout), which is human-readable but not machine-addressable. Promote it to frontmatter so both the infobox **and** the CSS generator read one source of truth:

```yaml
portrait: "[[astarion.png]]"   # or a path; optional, nullable
```

The infobox callout then references the property instead of a hardcoded filename. This is the enabling change, everything else in §1 depends on it.

### Open questions (icon system)

- **Regeneration trigger.** Manual command vs a hook on note create/rename. Start manual (`refresh-portraits`), reconsider if friction is real, mirrors the Templater "static is fine for v1" stance.
- **`data-href` stability.** Confirm Obsidian's `data-href` matches the note basename/path we'd key on, including for aliased links and links with display text. Needs a quick prototype check.
- **Portrait shape.** BG3 uses circular character portraits but square-ish item/spell sprites. Suggest: `border-radius: 50%` for `type: character`, square for items/locations. The generator can branch on `type`.
- **Retina / sizing.** 18px at 2× = 36px source minimum. Document a recommended portrait source size.
- **Reading view vs editing view.** Verify the snippet applies in both (Live Preview + Reading). CSS `::before` on `.internal-link` generally does, confirm in prototype.

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

1. **Add a `portrait` property** to every entity template (character, location, item, faction, lore). Optional/nullable. Powers the infobox and the icon CSS. Point the infobox callout at the property. *(Keystone, see §1.)*
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
