# Wave 2 — Text Quality Report

> Generated: 2026-03-03
> Scope: Text quality audit of all published content — curriculum activities (Batches A–C), standalone/template/gamepad activities, stories, curations, and global definitions
> Source tasks: T9 (Batch A), T10 (Batch B), T11 (Batch C), T12 (Standalones), T13 (Stories), T14 (Curations + Definitions)
> QA Mode: REPORT ONLY — zero content modifications made

---

## Summary

| Source | Files Scanned | Critical | Warning | Info | Total |
|--------|--------------|----------|---------|------|-------|
| T9 — Batch A (curriculums 1–26) | 26 curricula + 100 activities | 0 | 5 | 0 | 5 |
| T10 — Batch B (curriculums 27–52) | 26 curricula + 104 activities | 0 | 0 | 24 | 24 |
| T11 — Batch C (curriculums 53–78) | 26 curricula + 149 activities | 0 | 0 | 0 | 0 |
| T12 — Standalone/Template/Gamepad | 11 + 18 + 4 = 33 activities | 0 | 19 | 20 | 39 |
| T13 — Stories | 6 stories (52 pages) | 0 | 6 | 2 | 8 |
| T14 — Curations + Definitions | 40 curations + 6 definitions | 1 | 9 | 3 | 13 |
| **TOTAL** | **516 files** | **1** | **39** | **49** | **89** |

**Overall health: 1 critical issue, 39 warnings, 49 info notices across 516 files.**

---

## Findings by Content Type

### 1. Curriculum Activities — Batch A (T9)

**26 curricula + 100 activities scanned | 5 findings (0 critical, 5 warning, 0 info)**

All 5 findings are concentrated in a single curriculum: `curriculum_categorization_sort_through_functional_category-64388748AF714B4880B8C7B6DD6D93F3`.

| # | File (relative to `curriculums/`) | Field | Locale | Severity | Issue |
|---|----------------------------------|-------|--------|----------|-------|
| 1 | `curriculum_categorization_sort_through_functional_category-64388.../new_activities/categorization_sort_through_functional_category_1_image-DA072AA2...yml` | `l10n[fr_FR].details.instructions` | fr_FR | warning | Typo: `"Lorsque la réponse est correct"` → `"correcte"` (feminine agreement) |
| 2 | `curriculum_categorization_sort_through_functional_category-64388.../new_activities/categorization_sort_through_functional_category_2_images-F617D5D9...yml` | `l10n[fr_FR].details.instructions` | fr_FR | warning | Same typo: `"réponse est correct"` → `"correcte"` |
| 3 | `curriculum_categorization_sort_through_functional_category-64388.../new_activities/categorization_sort_through_functional_category_without_error-4AD006AA...yml` | `l10n[fr_FR].details.instructions` | fr_FR | warning | Same typo: `"réponse est correct"` → `"correcte"` |
| 4 | `curriculum_categorization_sort_through_functional_category-64388.../new_activities/categorization_sort_through_functional_category_6_images-DA01E28D...yml` | `l10n[en_US].details.instructions` | en_US | warning | Corrupted/truncated sentence with internal token: `"dropzone_pictograms-objects-house-bedroom-bed_blue-01A5room"` |
| 5 | `curriculum_categorization_sort_through_functional_category-64388.../new_activities/categorization_sort_through_functional_category_without_error-4AD006AA...yml` | `l10n[en_US].details.instructions` | en_US | warning | Grammar error: `"they that have to be grouped"` → `"that have to be grouped"` or `"which have to be grouped"` |

---

### 2. Curriculum Activities — Batch B (T10)

**26 curricula + 104 activities scanned | 24 findings (0 critical, 0 warning, 24 info)**

All 24 findings are "extra spaces" in subtitle or description fields. Three curricula are affected: `order_by_size_different_animals`, `recognition_alphabet_letters_3`, `recognition_alphabet_letters_4`, and `recognition_alphabet_letters_5`.

| # | File (relative to `curriculums/`) | Field | Locale | Severity | Issue |
|---|----------------------------------|-------|--------|----------|-------|
| 6 | `curriculum_order_by_size_different_animals-3158E58D.../curriculum_order_by_size_different_animals-3158E58D....curriculum.yml` | `l10n.details.description` | fr_FR | info | Extra spaces detected |
| 7 | `curriculum_order_by_size_different_animals-3158E58D.../curriculum_order_by_size_different_animals-3158E58D....curriculum.yml` | `l10n.details.description` | en_US | info | Extra spaces detected |
| 8 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../curriculum_recognition_alphabet_letters_3-ECDA6859....curriculum.yml` | `l10n.details.abstract` | fr_FR | info | Extra spaces detected |
| 9 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../curriculum_recognition_alphabet_letters_3-ECDA6859....curriculum.yml` | `l10n.details.abstract` | en_US | info | Extra spaces detected |
| 10 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../new_activities/recognition_alphabet_letters_3_2-B4D3D782...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 11 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../new_activities/recognition_alphabet_letters_3_2-B4D3D782...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 12 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../new_activities/recognition_alphabet_letters_3_4-3163D002...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 13 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../new_activities/recognition_alphabet_letters_3_4-3163D002...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 14 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../new_activities/recognition_alphabet_letters_3_6-9EA46A77...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 15 | `curriculum_recognition_alphabet_letters_3-ECDA6859.../new_activities/recognition_alphabet_letters_3_6-9EA46A77...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 16 | `curriculum_recognition_alphabet_letters_4-23997B52.../curriculum_recognition_alphabet_letters_4-23997B52....curriculum.yml` | `l10n.details.abstract` | fr_FR | info | Extra spaces detected |
| 17 | `curriculum_recognition_alphabet_letters_4-23997B52.../curriculum_recognition_alphabet_letters_4-23997B52....curriculum.yml` | `l10n.details.abstract` | en_US | info | Extra spaces detected |
| 18 | `curriculum_recognition_alphabet_letters_4-23997B52.../new_activities/recognition_alphabet_letters_4_2-12C97237...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 19 | `curriculum_recognition_alphabet_letters_4-23997B52.../new_activities/recognition_alphabet_letters_4_2-12C97237...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 20 | `curriculum_recognition_alphabet_letters_4-23997B52.../new_activities/recognition_alphabet_letters_4_4-0F187A5F...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 21 | `curriculum_recognition_alphabet_letters_4-23997B52.../new_activities/recognition_alphabet_letters_4_4-0F187A5F...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 22 | `curriculum_recognition_alphabet_letters_4-23997B52.../new_activities/recognition_alphabet_letters_4_6-D255CFBB...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 23 | `curriculum_recognition_alphabet_letters_4-23997B52.../new_activities/recognition_alphabet_letters_4_6-D255CFBB...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 24 | `curriculum_recognition_alphabet_letters_5-2B6FFBF9.../new_activities/recognition_alphabet_letters_5_2-6C29041B...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 25 | `curriculum_recognition_alphabet_letters_5-2B6FFBF9.../new_activities/recognition_alphabet_letters_5_2-6C29041B...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 26 | `curriculum_recognition_alphabet_letters_5-2B6FFBF9.../new_activities/recognition_alphabet_letters_5_4-AAF4E779...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 27 | `curriculum_recognition_alphabet_letters_5-2B6FFBF9.../new_activities/recognition_alphabet_letters_5_4-AAF4E779...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |
| 28 | `curriculum_recognition_alphabet_letters_5-2B6FFBF9.../new_activities/recognition_alphabet_letters_5_6-FFD60233...yml` | `l10n.details.subtitle` | fr_FR | info | Extra spaces detected |
| 29 | `curriculum_recognition_alphabet_letters_5-2B6FFBF9.../new_activities/recognition_alphabet_letters_5_6-FFD60233...yml` | `l10n.details.subtitle` | en_US | info | Extra spaces detected |

---

### 3. Curriculum Activities — Batch C (T11)

**26 curricula + 149 activities scanned | 0 findings**

> No issues found. Batch C is fully clean across all text fields reviewed.

---

### 4. Standalone Activities / Templates / Gamepads (T12)

**11 standalones + 18 templates + 4 gamepads = 33 activities scanned | 39 findings (0 critical, 19 warning, 20 info)**

| # | File | Field | Locale | Severity | Issue |
|---|------|-------|--------|----------|-------|
| 30 | `super_simon_2_colors` | `instructions` (last bullet) | fr_FR | warning | Truncated sentence: `"...Leka initiera un renforçateur pour encourager la personne"` — no object, no period |
| 31 | `super_simon_2_colors` | `instructions` (last bullet) | en_US | warning | Truncated sentence: `"...Leka will initiate a reinforcer to encourage the care receiver"` — dangling, no period |
| 32 | `super_simon_4_colors` | `instructions` (last bullet) | fr_FR | warning | Same truncation as finding #30 |
| 33 | `super_simon_4_colors` | `instructions` (last bullet) | en_US | warning | Same truncation as finding #31 |
| 34 | `super_simon_6_colors` | `instructions` (last bullet) | fr_FR | warning | Same truncation as finding #30 |
| 35 | `super_simon_6_colors` | `instructions` (last bullet) | en_US | warning | Same truncation as finding #31 |
| 36 | `activity_template` | exercise instruction #2 | fr_FR | warning | `"Touch le rond jaune"` — missing final 'e'; imperative is `"Touche"` |
| 37 | `activity_template` | exercise instruction #3 | fr_FR | warning | `"Touch la pastèque"` — missing final 'e'; imperative is `"Touche"` |
| 38 | `activity_template` | exercise instruction #4 | fr_FR | warning | `"Touch le carré"` — missing final 'e'; imperative is `"Touche"` |
| 39 | `touch_to_select_vanilla` | exercise instruction #3 | fr_FR | warning | `"Touch les symboles"` — missing final 'e'; imperative is `"Touche"` |
| 40 | `touch_to_select_action_listen` | exercise instruction #1 | fr_FR | warning | `"Ecoute et suis les instructions"` — missing capital accent É; should be `"Écoute"` |
| 41 | `touch_to_select_action_listen` | exercise instruction #2 | fr_FR | warning | `"Ecoute et choisis tous les bons éléments"` — missing É accent |
| 42 | `drag_and_drop_into_zones_action_listen` | exercise instruction #1 | fr_FR | warning | `"Ecoute et suis les instructions"` — missing É accent |
| 43 | `drag_and_drop_into_zones_action_listen` | exercise instruction #2 | fr_FR | warning | `"Ecoute et glisse l'animal dans le panier"` — missing É accent |
| 44 | `drag_and_drop_to_associate_action_listen` | exercise instruction #1 | fr_FR | warning | `"Ecoute et suis les instructions"` — missing É accent |
| 45 | `drag_and_drop_to_associate_action_listen` | exercise instruction #2 | fr_FR | warning | `"Ecoute et groupe les mêmes animaux ensemble"` — missing É accent |
| 46 | `memory` | exercise instruction #3 | fr_FR | warning | `"...trouve les paires de sfsymbol identiques"` — internal technical term `sfsymbol` exposed in user-facing text |
| 47 | `memory` | exercise instruction #3 | en_US | warning | `"...find the identical sfsymbol pairs"` — internal technical term `sfsymbol` exposed in user-facing text |
| 48 | `gamepad_joystick_color_pad` | exercise instruction | fr_FR | warning | `"fais le se déplacer"` — missing hyphen; should be `"fais-le se déplacer"` |
| 49 | `gamepad_arrow_pad_color_pad` | exercise instruction | en_US | warning | `"throw the reinforcer of your choice"` — awkward translation of `"lance le renforçateur"`; better: `"trigger"` / `"activate"` / `"launch"` |
| 50 | `gamepad_joystick_color_pad` | exercise instruction | en_US | warning | `"throw the reinforcer of your choice"` — same awkward translation |
| 51 | `activity_template` | `short_description`, `description`, `instructions` | both | info | Template placeholder text present (`"Courte description de l'activité"`, `"bla bla bla"`) — intentional for template |
| 52 | `touch_to_select_vanilla` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 53 | `touch_to_select_action_listen` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 54 | `touch_to_select_action_observe` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 55 | `touch_to_select_action_robot` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 56 | `0_touch_to_select_0_find_the_right_answers` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 57 | `0_touch_to_select_1_find_the_right_order` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 58 | `0_touch_to_select_2_associate_categories` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 59 | `drag_and_drop_in_order_vanilla` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 60 | `drag_and_drop_into_zones_vanilla` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 61 | `drag_and_drop_into_zones_action_listen` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 62 | `drag_and_drop_into_zones_action_observe` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 63 | `drag_and_drop_into_zones_action_robot` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 64 | `drag_and_drop_to_associate_vanilla` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 65 | `drag_and_drop_to_associate_action_listen` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 66 | `drag_and_drop_to_associate_action_observe` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 67 | `drag_and_drop_to_associate_action_robot` | `short_description`, `description`, `instructions` | both | info | Lorem ipsum placeholder text — intentional for template |
| 68 | `memory` | `subtitle` | both | info | Empty subtitle field (`subtitle:` with no value) — consistent with template status |

---

### 5. Stories (T13)

**6 stories (52 pages) scanned | 8 findings (0 critical, 6 warning, 2 info)**

| # | File | Field | Locale | Severity | Issue |
|---|------|-------|--------|----------|-------|
| 69 | all 6 stories (shared boilerplate) | `instructions` bullet 1–3 | en_US | info | French typographic space before colon carried into English: `"Explore the story :"` → `"Explore the story:"` |
| 70 | `first_day_of_school-8DE906A4...story.yml` | page 9 `items[4].payload.text` | en_US | warning | `"drives Hanna to school with his car"` — unnatural; standard phrasing is `"in his car"` |
| 71 | `hanna_at_the_beach-60C133CB...story.yml` | page 2 vs page 3 character label | en_US | warning | Same character (Nagib) labelled `"Father"` (page 2) then `"Dad"` (page 3) within the same story; FR uses `"Papa"` consistently |
| 72 | `hanna_at_the_beach-60C133CB...story.yml` | page 7 `items[4].payload.text` | en_US | warning | `"had a great fun"` — grammatically incorrect; `fun` is uncountable here; → `"had great fun"` or `"had a great time"` |
| 73 | `hanna_dances_with_leka-47509B00...story.yml` | `l10n[].details.title` | en_US | warning | FR title `"Hanna Danse avec Leka"` vs EN title `"Let's Dance"` — EN omits both character names; significant divergence |
| 74 | `hanna_makes_pancakes-5213404A...story.yml` | page 6 `items[1].payload.text` | en_US | warning | `"puts also 2 tablespoons of sugar"` — inverted word order; → `"also puts 2 tablespoons of sugar"` |
| 75 | `hanna_makes_pancakes-5213404A...story.yml` | page 7 `items[2].payload.text` | fr_FR | warning | `"fait un puit dans le saladier"` — misspelling; `"puit"` → `"puits"` (always written with final -s) |
| 76 | `hanna_makes_pancakes-5213404A...story.yml` | page 12 vs page 14 character label | en_US | info | Same character labelled `"Dad"` (page 12) then `"Daddy"` (page 14) — both valid but inconsistent within a single story |

---

### 6. Curations + Global Definitions (T14)

**40 curations + 6 definitions scanned | 13 findings (1 critical, 9 warning, 3 info)**

| # | File | Field | Locale | Severity | Issue |
|---|------|-------|--------|----------|-------|
| 77 | `definitions/tags.yml` | `description` (all 77 tags) | fr_FR + en_US | **critical** | Every tag description contains `"Lorem ipsum"` placeholder — 77 tags × 2 locales = 154 unfilled description fields |
| 78 | `definitions/activity_types.yml` | `list[id=group].l10n[fr_FR].description` | fr_FR | warning | Typo: `"accommpagnées"` (double 'm') → `"accompagnées"` |
| 79 | `definitions/skills.yml` | `communication/verbal_communication/expressive_language/written_expression.l10n[en_US].name` | en_US | warning | Wrong name copy-pasted from sibling skill: `"Written comprehension (reading)"` should be `"Written expression (writing)"` |
| 80 | `definitions/skills.yml` | `generalization.l10n[en_US].description` | en_US | warning | Missing word: `"different colors shapes"` → `"different colors or shapes"` |
| 81 | `definitions/skills.yml` | `sensory_integration/touch.l10n[fr_FR].description` | fr_FR | warning | Mixed conjugation: `"manipule ou jouer"` (indicative + infinitive) → `"manipule ou joue"` |
| 82 | `curations/curriculums-2685B06A....curation.yml` | `content[Festivités].l10n[en_US].details.description` | en_US | warning | Trailing double period: `"for the holidays.."` — extra period |
| 83 | `curations/sandbox-4B476A0D....curation.yml` | `l10n.details.title` | fr_FR + en_US | warning | Top-level title is `"Accueil"` / `"Home"` — same as home curation; appears copy-pasted and not updated for sandbox context |
| 84 | `curations/subcurations/autonomy_and_daily_life-D680A316....curation.yml` | section titles (3 occurrences, lines 26/56/78) | fr_FR | warning | Typo `"autours"` in 3 section titles — not a standard French word; → `"autour"` |
| 85 | `curations/subcurations/weather_and_environment-572F710A....curation.yml` | section titles (3 occurrences, lines 26/44/60) | fr_FR | warning | Same typo `"autours"` in 3 section titles → `"autour"` |
| 86 | `curations/subcurations/fine_motor_skills-EFBB68F0....curation.yml` | `content[2].l10n[en_US].details.title` | en_US | warning | Wrong EN section title — copy-pasted from drag-and-drop section; FR title is about préhension (grasping), not drag-and-drop |
| 87 | `curations/subcurations/gross_motor_skills-63BB71F5....curation.yml` | `content[0].l10n[en_US].details.title` | en_US | info | Non-standard EN typography: `"Activities to move with Leka !"` — space before `!` is French convention, not English |
| 88 | `curations/subcurations/in_group-9D0EBC77....curation.yml` | `content[0].l10n[en_US].details.title` | en_US | info | Same non-standard EN spacing: `"Activities to move with Leka !"` |
| 89 | `curations/sandbox-4B476A0D....curation.yml` | `content[vertical_curation_grid].l10n[en_US].details.title` | en_US | info | Inconsistent capitalization: `"by learning objective"` — all other EN section titles start with uppercase |

---

## Recurring Issue Patterns

### Pattern 1: French gender agreement — `"correct"` instead of `"correcte"` (3 occurrences, fr_FR)
Files `categorization_sort_through_functional_category_1_image`, `_2_images`, `_without_error`. All share the same boilerplate instruction text. Fix: replace `"est correct"` with `"est correcte"` in the `fr_FR` instructions block of all three activities.

### Pattern 2: Missing capital accent — `"Ecoute"` instead of `"Écoute"` (6 occurrences, 3 template files, fr_FR)
Affects all three `_action_listen` template variants (`touch_to_select_action_listen`, `drag_and_drop_into_zones_action_listen`, `drag_and_drop_to_associate_action_listen`), 2 occurrences each. The shared boilerplate uses an unaccented capital E.

### Pattern 3: Truncated French imperative — `"Touch"` instead of `"Touche"` (4 occurrences, 2 files, fr_FR)
Affects `activity_template` (3 exercises) and `touch_to_select_vanilla` (1 exercise). English `"Touch"` is correct; the error is only in the French imperative form.

### Pattern 4: Truncated Super Simon instructions (3 × 2 locales = 6 occurrences)
All three `super_simon_*_colors` variants share identical instruction text with the last bullet syntactically incomplete in both FR and EN. Appears to be a copy-paste truncation never corrected across difficulty levels.

### Pattern 5: `"autours"` misspelling (6 occurrences, 2 curation files, fr_FR)
Repeated across `autonomy_and_daily_life` (3 section titles) and `weather_and_environment` (3 section titles). Standard French is `"autour"` (invariable).

### Pattern 6: `"throw the reinforcer"` awkward EN translation (2 occurrences)
Both `gamepad_arrow_pad_color_pad` and `gamepad_joystick_color_pad` use this literal translation of `"lance le renforçateur"`. Better English: `"trigger"`, `"activate"`, or `"launch"`.

### Pattern 7: Template placeholder text (18 template files, info-level)
All `new_templates/` files contain Lorem ipsum or equivalent placeholder text. This is intentional design for template files but flagged as info in case any template is accidentally referenced in production curations.

---

## Clean Areas (No Issues Found)

- **Batch C** (26 curricula, 149 activities): Fully clean across all reviewed text fields.
- **Standalone activities** — `color_mediator`, `dance_freeze`, `discover_leka`, `gamepad_arrow_pad_big`, `gamepad_color_pad`, `xylophone_heptatonic`, `xylophone_pentatonic`, `hide_and_seek`, `melody`, `color_music_pad`: All clean.
- **`definitions/`** — `authors.yml`, `robot_assets.yml`, `hmi.yml`: No issues.
- **Stories** — `hanna_meets_leka`, `hanna_plays_music`, `hanna_dances_with_leka` (except title divergence): Clean body text.
- **Extra spaces (T10)**: The 24 info-level findings are cosmetic whitespace only (no missing text, no wrong text). No user-facing impact.
