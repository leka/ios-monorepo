# Content QA Master Summary

> Generated: 2026-03-03
> Scope: All content under `Modules/ContentKit/Resources/Content/`
> Audit tasks: T8 (hooks), T9–T14 (text quality), T15 (integration)
> QA Mode: REPORT ONLY — zero content files modified

---

## Executive Summary

| Metric | Value |
|--------|-------|
| Total content files scanned | ~556 files |
| Total issues found (all waves) | **126** |
| Critical issues | **3** |
| Warning issues | **73** |
| Info issues | **50** |
| Pre-commit hooks evaluated | 12 |
| Hooks passing | 11 / 12 |
| Hook failing | 1 (`check_yaml_content_curations`) |
| Content files modified | **0** (audit-only) |

> **File count breakdown:** 78 curricula + 353 curriculum activities + 33 standalone/template/gamepad activities + 6 stories + 40 curations + 6 definitions + 40 other (YML infra) ≈ 556 files

---

## Severity Breakdown (All Waves)

| Severity | Count | Origin | Description |
|----------|-------|--------|-------------|
| **critical** | 3 | W1 (2), W2 (1) | Schema violations causing runtime failures; 154 unfilled Lorem ipsum fields in tags.yml |
| **warning** | 73 | W1 (21), W2 (39), W3 (13) | Typos, grammar errors, broken references, naming mismatches, stale curation links |
| **info** | 50 | W1 (1), W2 (49), W3 (up to 307+) | Extra whitespace, template placeholders, typography conventions, orphaned content |

> W3 (Wave 3) info counts are not fully itemised here; the 302 orphaned activities are expected/intentional and listed in wave-3-integration.md. Orphaned items are excluded from the 50-info total above, which covers only Wave 1 and Wave 2 info findings.

---

## Per-Content-Type Breakdown (Wave 2 Text Quality)

| Content Type | Files | Critical | Warning | Info | Total |
|-------------|-------|----------|---------|------|-------|
| Curriculum activities — Batch A (curricula 1–26) | 100 | 0 | 5 | 0 | 5 |
| Curriculum activities — Batch B (curricula 27–52) | 104 | 0 | 0 | 24 | 24 |
| Curriculum activities — Batch C (curricula 53–78) | 149 | 0 | 0 | 0 | 0 |
| Curricula (YML files themselves) | 78 | 0 | 0 | 0 | 0 |
| Standalone/Template/Gamepad activities | 33 | 0 | 19 | 20 | 39 |
| Stories | 6 | 0 | 6 | 2 | 8 |
| Curations | 40 | 0 | 6 | 3 | 9 |
| Definitions | 6 | 1 | 3 | 0 | 4 |
| **Wave 2 Total** | **516** | **1** | **39** | **49** | **89** |

---

## Wave 1 (Structural) Breakdown — Pre-commit Hook Results

| Hook | Status | Findings |
|------|--------|----------|
| `check_yaml_content_new_activities` | ✅ PASS | 0 |
| `check_yaml_content_curriculums` | ✅ PASS | 0 |
| `check_yaml_content_stories` | ✅ PASS | 0 |
| `check_yaml_content_curations` | ❌ FAIL | 2 schema + 21 unresolved refs + 1 info |
| `check_yaml_content_new_activities_unique_uuid` | ✅ PASS | 0 |
| `check_yaml_content_curriculums_unique_uuid` | ✅ PASS | 0 |
| `check_yaml_content_stories_unique_uuid` | ✅ PASS | 0 |
| `check_yaml_content_cross_type_unique_uuid` | ✅ PASS | 0 |
| `check_yaml_content_activities_assets` | ✅ PASS | 0 |
| `check_yaml_definitions_skills` | ✅ PASS | 0 |
| `check_yaml_definitions_tags` | ✅ PASS | 0 |
| `check_yaml_definitions_authors` | ✅ PASS | 0 |

**Wave 1 total: 2 critical, 21 warning, 1 info**

---

## Wave 3 (Integration) Breakdown — Directory + Orphan Audit

| Finding Type | Count | Severity |
|-------------|-------|----------|
| Curriculum directories missing `curriculum_` prefix | 3 | warning |
| Curriculum directories using deprecated `.curriculum` suffix | 3 | warning |
| Directory name ≠ YML `name:` field (resolution mismatch) | 2 | warning |
| Stale/duplicate curation references (incl. 1 ghost UUID) | 4 | warning |
| Orphaned published curriculum (not referenced in any curation) | 1 | warning |
| Directory with hyphen in name portion (parsing risk) | 1 | info |
| Curriculum directories missing `new_activities/` subdir | 2 | info |
| Orphaned published activities (curriculum-member variants) | 302 | info |

**Wave 3 total: 0 critical, 13 warning, 305 info** (302 orphaned activities are expected/intentional)

---

## Top Critical Issues — Fix First

### CRITICAL-1: `story` type not in curation JTD schema (Wave 1)
**Crash risk.** 2 curation files use `type: story` for their items, but the JTD schema only permits `curriculum`, `activity`, or `curation`. These curations will fail to decode at runtime.
- `curations/stories-EA36F26CEE7A495B878EB1285AFBA4D3.curation.yml` (6 items)
- `curations/subcurations/quiet_time-7A47BF7D73694FA9A364A256511EE809.curation.yml` (6 items)
**Fix:** Add `"story"` to the `type` enum in `Specs/jtd/curation.jtd.json`. Content team to coordinate with dev team to ensure story-type curation items are handled correctly at runtime.

### CRITICAL-2: Lorem ipsum in `definitions/tags.yml` (Wave 2)
**User-facing placeholder text.** All 77 tag descriptions contain `"Lorem ipsum"` in both `fr_FR` and `en_US` — 154 unfilled fields total. If tag descriptions are ever surfaced in the UI, users will see placeholder text.
**File:** `definitions/tags.yml`
**Fix:** Write real descriptions for all 77 tags, or mark the `description` field as optional in the schema if descriptions are not intended to be shown.

---

## Top Warnings — Fix Soon

### Warning Group A: Broken curation references (Wave 1 — 21 total)
Curations reference curricula/activities/subcurations that do not exist. Affected items silently disappear from the UI.

| File | Missing Items | Impact |
|------|--------------|--------|
| `curriculums-2685B06A....curation.yml` | 9 missing curricula (alphabet, order_by_size, cooked_fruits, christmas_memory) | Curriculums tab missing items |
| `mathematics-9D3BC845....curation.yml` | 1 missing curriculum (`counting_flower-petals`) | Mathematics subcuration missing item |
| `categorize_associate_organize-3B7D4928....curation.yml` | 2 missing curricula | Categorization subcuration incomplete |
| `magic_card_content-E6AEC63D....curation.yml` | 4 missing activities (magic_card_*) | Magic Card subcuration shows 4 gaps |
| `fine_motor_skills-EFBB68F0....curation.yml` | 4 missing activities (same magic_card_*) | Fine Motor Skills subcuration incomplete |
| `sandbox-4B476A0D....curation.yml` | 1 missing curation (`by_theme`) | Sandbox tab missing item |

### Warning Group B: Naming mismatches causing resolution failures (Wave 3 — 4 refs)
Stale names in curations no longer match actual content `name:` fields:
1. `curriculum_christmas_memory` → correct is `curriculum_memory_christmas`
2. `curriculum_recognition_cooked_fruits-723490A2...` → ghost UUID (does not exist; correct UUID is `C0D2DAE8...`)
3. `curriculum_categorization_sorting_fruits_vegetables_basket-E6A322DC...` → YML `name:` is `sorting_fruits_vegetables_basket-...`
4. `curriculum_counting_flower-petals-...` → YML `name:` uses underscore, not hyphen

### Warning Group C: French grammar/spelling in definitions (Wave 2 — 4 occurrences)
- `skills.yml`: Wrong EN name for `written_expression` skill (copy-pasted from sibling)
- `skills.yml`: Missing word in EN `generalization` description (`"colors shapes"` → `"colors or shapes"`)
- `skills.yml`: Mixed conjugation in FR `sensory_integration/touch` description
- `activity_types.yml`: Typo `"accommpagnées"` in FR group description

### Warning Group D: Recurring template text errors (Wave 2)
- 3 files: `"Ecoute"` → `"Écoute"` (6 occurrences in `_action_listen` templates)
- 3 files: Truncated Super Simon instructions (6 occurrences, all difficulty levels)
- 2 files: `"Touch"` → `"Touche"` (4 occurrences, fr_FR imperatives)
- 2 files: `"throw the reinforcer"` → better EN translation in gamepad activities
- 2 curation files: `"autours"` → `"autour"` (6 section title occurrences)

---

## Hook Infrastructure Improvements (Added During QA)

The following pre-commit hooks and schemas were added or fixed during this QA cycle (T1–T8):

| Hook / Change | Purpose | Before |
|--------------|---------|--------|
| `check_yaml_content_curations` | Validates curation YAML against JTD schema + checks cross-references | No validation existed |
| `Specs/jtd/curation.jtd.json` | JTD schema for curation files | Did not exist |
| `check_yaml_content_new_activities_unique_uuid` | Detects duplicate UUIDs in v2 activity files | Did not exist |
| `check_yaml_content_cross_type_unique_uuid` | Detects UUID collisions across content types | Did not exist |
| Fixed unreferenced-activities hook | Now checks `new_activities/` (not old `activities/`) | Was checking deprecated path |
| Fixed author enum in 3 JTD schemas | Matches actual `authors.yml` values | Was rejecting valid authors |

**Hook coverage after QA:** 12 hooks running, 11/12 passing. The single failing hook (`check_yaml_content_curations`) surfaces real content issues (schema violations + broken references) documented in Wave 1.

---

## Known Structural Issues (from Wave 1)

1. **JTD enum missing `story` type** → 2 curations fail schema validation → crash/empty screen risk
2. **9 curricula referenced but not created** (alphabet series, order_by_size, etc.) → gaps in Curriculums tab
3. **4 `magic_card_*` activities referenced but not created** → known content gap, affects 2 subcurations
4. **1 ghost UUID** (`curriculum_recognition_cooked_fruits-723490A2...`) → stale reference
5. **Multi-hyphen name parsing** in `CurationItemModel` → structural code bug, only `counting_flower-petals` currently affected

---

## Recommendations (Priority Order)

### Priority 1 — CRITICAL (crash/blank screen risk)
1. **Add `story` to curation JTD enum** (`Specs/jtd/curation.jtd.json`): Add `"story"` to the `type` enum. Content team to coordinate with dev team to ensure story-type curation items are handled correctly at runtime. Affects `stories-EA36F26C` and `quiet_time-7A47BF7D` curations.

### Priority 2 — HIGH (broken references causing missing UI content)
2. **Create missing curricula** referenced in `curriculums-2685B06A` curation: `curriculum_recognition_alphabet_letters_a_to_f`, `curriculum_alphabet_letters_sounds_a_to_f`, `curriculum_alphabetical_order_a_to_f`, `curriculum_order_by_size`, `curriculum_recognition_cooked_fruits`, `curriculum_christmas_memory`.
3. **Fix stale curation references**: Update `curriculum_christmas_memory` → `curriculum_memory_christmas`, fix ghost UUID for `cooked_fruits`, and correct the `sorting_fruits_vegetables_basket` and `counting_flower-petals` reference formats.
4. **Create or remove the missing `by_theme` subcuration** referenced in `sandbox-4B476A0D`.

### Priority 3 — MEDIUM (content quality / user trust)
5. **Fill in `definitions/tags.yml` descriptions**: Replace all 154 Lorem ipsum placeholder values with real descriptions in both `fr_FR` and `en_US`.
6. **Fix skills.yml errors** (4 issues): wrong `written_expression` EN name, missing word in `generalization` description, mixed conjugation in `touch` FR description.
7. **Fix `"Écoute"` accent** in 3 `_action_listen` template files (6 occurrences).
8. **Complete Super Simon instructions**: All 3 difficulty variants have truncated last bullet in both FR and EN.
9. **Fix `"autours"` typo** in `autonomy_and_daily_life` and `weather_and_environment` subcuration titles (6 occurrences).

### Priority 4 — LOW (polish)
10. **Replace `sfsymbol` in `memory` template** instructions with user-friendly text.
11. **Fix `"Touch"` → `"Touche"`** in `activity_template` and `touch_to_select_vanilla` (4 occurrences).
12. **Fix `"throw the reinforcer"`** EN translation in 2 gamepad files.
13. **Normalize `fine_motor_skills` curation section title** (EN copy-paste from wrong section).
14. **Rename `sandbox` curation title** from `"Accueil"/"Home"` to correct sandbox label.
15. **Fix minor story text issues**: `"with his car"` → `"in his car"`, `"had a great fun"` → `"had great fun"`, inverted word order in pancakes story, `"puit"` → `"puits"`.
16. **Standardize EN typography**: Remove `" !"` (space-exclamation) in 2 curation titles; remove space before `:` in story instructions boilerplate.
17. **Fix extra spaces** in subtitle/description of alphabet recognition curricula and `order_by_size_different_animals` curriculum (24 info items).

### Priority 5 — STRUCTURAL (code-level fixes, not content)
18. **Rename curriculum directory** to avoid internal hyphen in name portion: rename `curriculum_counting_flower-petals` to `curriculum_counting_flower_petals` (affects 1 directory). Content team to coordinate with dev team on the rename.
19. **Standardize curriculum directory naming**: Add `curriculum_` prefix to `color_bingo` and `super_simon` directories; migrate 3 `.curriculum` bundle-suffix directories to plain directories.

---

## Related Reports

| Report | Location | Contents |
|--------|----------|----------|
| Wave 1 — Structural | `qa-reports/wave-1-structural.md` | Full hook output, all structural findings with detail |
| Wave 2 — Text Quality | `qa-reports/wave-2-text-quality.md` | All 89 text quality findings across 516 files |
| Wave 3 — Integration | `qa-reports/wave-3-integration.md` | Directory naming audit + orphaned content detection |
| Wave 1 existing validators | `qa-reports/wave-1-existing-validators.md` | Pre-existing hook baseline before QA cycle |
