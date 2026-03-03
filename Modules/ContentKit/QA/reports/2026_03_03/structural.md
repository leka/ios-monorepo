# Wave 1 — Structural Baseline Report

Generated: 2026-03-03
Scope: All pre-commit content hooks run against all files
QA Mode: REPORT ONLY — zero content modifications made

---

## Summary Table

| Hook | Status | Findings |
|------|--------|----------|
| `check_yaml_content_new_activities` | ✅ PASS | 0 issues |
| `check_yaml_content_curriculums` | ✅ PASS | 0 issues |
| `check_yaml_content_stories` | ✅ PASS | 0 issues |
| `check_yaml_content_curations` | ❌ FAIL | 2 schema violations + 6 unresolved refs groups |
| `check_yaml_content_new_activities_unique_uuid` | ✅ PASS | 0 collisions |
| `check_yaml_content_curriculums_unique_uuid` | ✅ PASS | 0 collisions |
| `check_yaml_content_stories_unique_uuid` | ✅ PASS | 0 collisions |
| `check_yaml_content_cross_type_unique_uuid` | ✅ PASS | 0 cross-type collisions |
| `check_yaml_content_activities_assets` | ✅ PASS | 0 issues |
| `check_yaml_definitions_skills` | ✅ PASS | 0 issues |
| `check_yaml_definitions_tags` | ✅ PASS | 0 issues |
| `check_yaml_definitions_authors` | ✅ PASS | 0 issues |

**Overall: 1 hook FAILING out of 12**

---

## Critical Issues (crash risk)

### CRITICAL-1: Schema violation — `story` is not a valid curation item type

**Severity:** CRITICAL
**Hook:** `check_yaml_content_curations`
**Files affected:**
- `curations/stories-EA36F26CEE7A495B878EB1285AFBA4D3.curation.yml` — 6 items with `type: story`
- `curations/subcurations/quiet_time-7A47BF7D73694FA9A364A256511EE809.curation.yml` — 6 items with `type: story`

**Detail:** The JTD schema `Specs/jtd/curation.jtd.json` only permits `type` values of `curriculum`, `activity`, or `curation`. Both files use `type: story` for their items. This will cause decoding failures at runtime when the app tries to load these curations — the `type` field cannot be decoded into the enum.

**Impact:** The Stories tab curation and the `quiet_time` subcuration will fail to load, resulting in empty or crash screens for those sections.

---

## Warnings

### WARNING-1: Unresolved curriculum references in `curriculums-2685B06A51324C31A255B50D8A2AD064.curation.yml`

**Severity:** WARNING
**Hook:** `check_yaml_content_curations`
**File:** `curations/curriculums-2685B06A51324C31A255B50D8A2AD064.curation.yml`

**Missing curricula (9 references):**
- `content/0/items/0` → `curriculum_recognition_alphabet_letters_a_to_f-50DC12AA75AA4ED48928FBAFB73CA7EF`
- `content/0/items/1` → `curriculum_alphabet_letters_sounds_a_to_f-C157BAD4AA044EE89A941B1D868FFEB7`
- `content/0/items/2` → `curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978`
- `content/2/items/2` → `curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978` (duplicate ref)
- `content/2/items/5` → `curriculum_order_by_size-1FAED1FF14134571849325B6EC9197B5`
- `content/8/items/8` → `curriculum_order_by_size-1FAED1FF14134571849325B6EC9197B5` (duplicate ref)
- `content/14/items/3` → `curriculum_recognition_cooked_fruits-723490A27448424EAFCB7D75444E0480`
- `content/16/items/5` → `curriculum_recognition_cooked_fruits-723490A27448424EAFCB7D75444E0480` (duplicate ref)
- `content/17/items/0` → `curriculum_christmas_memory-EFC444BBDEF24E08813FF472FFA5365D`

**Impact:** These items will not render in the Curriculums tab. Content appears missing to users but no crash expected (items silently skipped or empty).

---

### WARNING-2: Unresolved curriculum reference in `mathematics-9D3BC84542E44614922FE450EC2F7F58.curation.yml`

**Severity:** WARNING
**Hook:** `check_yaml_content_curations`
**File:** `curations/subcurations/mathematics-9D3BC84542E44614922FE450EC2F7F58.curation.yml`

**Missing curriculum (1 reference):**
- `content/0/items/3` → `curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1`

**Additional note (INFO):** The name `curriculum_counting_flower-petals` contains multiple hyphens. The hook warns that `CurationItemModel` splits on all hyphens and may truncate the name to `curriculum_counting_flower`, causing a lookup failure even if the curriculum existed.

**Impact:** One missing curriculum item in the Mathematics subcuration.

---

### WARNING-3: Unresolved references in `categorize_associate_organize-3B7D4928FF4B498F9DAA16FF50933979.curation.yml`

**Severity:** WARNING
**Hook:** `check_yaml_content_curations`
**File:** `curations/subcurations/categorize_associate_organize-3B7D4928FF4B498F9DAA16FF50933979.curation.yml`

**Missing references (2):**
- `content/0/items/8` → `curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978` (curriculum)
- `content/1/items/0` → `curriculum_categorization_sorting_fruits_vegetables_basket-E6A322DC7A6E48518CED2CA2D3D2A595` (curriculum)

**Impact:** Two missing items in this categorization/sorting subcuration.

---

### WARNING-4: Unresolved `magic_card_*` activity references in `magic_card_content-E6AEC63DF38F467E9C9974931017E47A.curation.yml`

**Severity:** WARNING
**Hook:** `check_yaml_content_curations`
**File:** `curations/subcurations/magic_card_content-E6AEC63DF38F467E9C9974931017E47A.curation.yml`

**Missing activities (4):**
- `content/0/items/1` → `magic_card_belt_color_recognition-D3E24B95730848329B122769B077E65C`
- `content/0/items/2` → `magic_card_screen_color_recognition-64C2CDF7DAA240CEB195F1BBE13941E3`
- `content/0/items/3` → `magic_card_leka_emotion_recognition-6BFDE930EBA7462AAC828D09843D7747`
- `content/0/items/4` → `magic_card_child_emotion_recognition-A40CA9F3F50A4FD58DB9FF40B7DC69BB`

**Note:** Per inherited wisdom, these are known real content gaps — the `magic_card_*` activities are referenced but not yet created as v2 activities.

**Impact:** Magic card content subcuration shows 4 missing activity items.

---

### WARNING-5: Unresolved `magic_card_*` activity references in `fine_motor_skills-EFBB68F0B3D84A32B08A688CC2F9B8F0.curation.yml`

**Severity:** WARNING
**Hook:** `check_yaml_content_curations`
**File:** `curations/subcurations/fine_motor_skills-EFBB68F0B3D84A32B08A688CC2F9B8F0.curation.yml`

**Missing activities (4, same as WARNING-4):**
- `content/2/items/1` → `magic_card_belt_color_recognition-D3E24B95730848329B122769B077E65C`
- `content/2/items/2` → `magic_card_screen_color_recognition-64C2CDF7DAA240CEB195F1BBE13941E3`
- `content/2/items/3` → `magic_card_leka_emotion_recognition-6BFDE930EBA7462AAC828D09843D7747`
- `content/2/items/4` → `magic_card_child_emotion_recognition-A40CA9F3F50A4FD58DB9FF40B7DC69BB`

**Impact:** Same magic card activities missing in the Fine Motor Skills subcuration.

---

### WARNING-6: Unresolved curation reference in `sandbox-4B476A0DFDC044B98DCBC631FF4EA27B.curation.yml`

**Severity:** WARNING
**Hook:** `check_yaml_content_curations`
**File:** `curations/sandbox-4B476A0DFDC044B98DCBC631FF4EA27B.curation.yml`

**Missing curation (1):**
- `content/7/items/5` → `by_theme-F83E2947CE8F40D1B6B8798042F3D31A` (curation)

**Impact:** One missing subcuration item in the Sandbox tab.

---

## Info

### INFO-1: Multi-hyphen name parsing caveat

`CurationItemModel` splits on all hyphens to separate name from UUID. Any curriculum/activity name containing hyphens (e.g., `curriculum_counting_flower-petals-<UUID>`) will be parsed incorrectly — the name will be truncated at the first internal hyphen. This is a structural parsing bug, not a content bug. Only `curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1` is flagged in this scan.

---

## Per-Hook Output

### check_yaml_content_new_activities
```
Check new_activity.yml files.............................................Passed
```

### check_yaml_content_curriculums
```
Check curriculum.yml files...............................................Passed
```

### check_yaml_content_stories
```
Check story.yml files....................................................Passed
```

### check_yaml_content_curations
```
Check curation.yml files.................................................Failed
- hook id: check_yaml_content_curations
- exit code: 1

Checking 4 curation files...

✅ All curation files are valid!

Checking 4 curation files...

✅ All curation files are valid!

Checking 4 curation files...

❌ Found unresolved curation item references in Modules/ContentKit/Resources/Content/curations/subcurations/mathematics-9D3BC84542E44614922FE450EC2F7F58.curation.yml
  - content/0/items/3: curriculum -> curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1

ℹ️ Found multi-hyphen curation item names in Modules/ContentKit/Resources/Content/curations/subcurations/mathematics-9D3BC84542E44614922FE450EC2F7F58.curation.yml
   CurationItemModel splits on all hyphens and may truncate names.
  - content/0/items/3/value: curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1

Checking 4 curation files...

❌ Found unresolved curation item references in Modules/ContentKit/Resources/Content/curations/curriculums-2685B06A51324C31A255B50D8A2AD064.curation.yml
  - content/0/items/0: curriculum -> curriculum_recognition_alphabet_letters_a_to_f-50DC12AA75AA4ED48928FBAFB73CA7EF
  - content/0/items/1: curriculum -> curriculum_alphabet_letters_sounds_a_to_f-C157BAD4AA044EE89A941B1D868FFEB7
  - content/0/items/2: curriculum -> curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978
  - content/2/items/2: curriculum -> curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978
  - content/2/items/5: curriculum -> curriculum_order_by_size-1FAED1FF14134571849325B6EC9197B5
  - content/8/items/8: curriculum -> curriculum_order_by_size-1FAED1FF14134571849325B6EC9197B5
  - content/14/items/3: curriculum -> curriculum_recognition_cooked_fruits-723490A27448424EAFCB7D75444E0480
  - content/16/items/5: curriculum -> curriculum_recognition_cooked_fruits-723490A27448424EAFCB7D75444E0480
  - content/17/items/0: curriculum -> curriculum_christmas_memory-EFC444BBDEF24E08813FF472FFA5365D

❌ File does not match the schema Specs/jtd/curation.jtd.json
Modules/ContentKit/Resources/Content/curations/stories-EA36F26CEE7A495B878EB1285AFBA4D3.curation.yml invalid
[
  {
    instancePath: '/content/0/items/0/type',
    schemaPath: '/definitions/$item/properties/type/enum',
    keyword: 'enum',
    params: { allowedValues: [Array] },
    message: 'must be equal to one of the allowed values',
    schema: [ 'curriculum', 'activity', 'curation' ],
    parentSchema: { enum: [Array] },
    data: 'story'
  },
  { instancePath: '/content/0/items/1/type', ... data: 'story' },
  { instancePath: '/content/0/items/2/type', ... data: 'story' },
  { instancePath: '/content/0/items/3/type', ... data: 'story' },
  { instancePath: '/content/0/items/4/type', ... data: 'story' },
  { instancePath: '/content/0/items/5/type', ... data: 'story' }
]

❌ Schema validation failed for Modules/ContentKit/Resources/Content/curations/stories-EA36F26CEE7A495B878EB1285AFBA4D3.curation.yml

Checking 4 curation files...

❌ Found unresolved curation item references in Modules/ContentKit/Resources/Content/curations/subcurations/categorize_associate_organize-3B7D4928FF4B498F9DAA16FF50933979.curation.yml
  - content/0/items/8: curriculum -> curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978
  - content/1/items/0: curriculum -> curriculum_categorization_sorting_fruits_vegetables_basket-E6A322DC7A6E48518CED2CA2D3D2A595

Checking 4 curation files...

❌ File does not match the schema Specs/jtd/curation.jtd.json
Modules/ContentKit/Resources/Content/curations/subcurations/quiet_time-7A47BF7D73694FA9A364A256511EE809.curation.yml invalid
[
  { instancePath: '/content/0/items/0/type', ... data: 'story' },
  { instancePath: '/content/0/items/1/type', ... data: 'story' },
  { instancePath: '/content/0/items/2/type', ... data: 'story' },
  { instancePath: '/content/0/items/3/type', ... data: 'story' },
  { instancePath: '/content/0/items/4/type', ... data: 'story' },
  { instancePath: '/content/0/items/5/type', ... data: 'story' }
]

❌ Schema validation failed for Modules/ContentKit/Resources/Content/curations/subcurations/quiet_time-7A47BF7D73694FA9A364A256511EE809.curation.yml

❌ Found unresolved curation item references in Modules/ContentKit/Resources/Content/curations/sandbox-4B476A0DFDC044B98DCBC631FF4EA27B.curation.yml
  - content/7/items/5: curation -> by_theme-F83E2947CE8F40D1B6B8798042F3D31A

Checking 4 curation files...

❌ Found unresolved curation item references in Modules/ContentKit/Resources/Content/curations/subcurations/magic_card_content-E6AEC63DF38F467E9C9974931017E47A.curation.yml
  - content/0/items/1: activity -> magic_card_belt_color_recognition-D3E24B95730848329B122769B077E65C
  - content/0/items/2: activity -> magic_card_screen_color_recognition-64C2CDF7DAA240CEB195F1BBE13941E3
  - content/0/items/3: activity -> magic_card_leka_emotion_recognition-6BFDE930EBA7462AAC828D09843D7747
  - content/0/items/4: activity -> magic_card_child_emotion_recognition-A40CA9F3F50A4FD58DB9FF40B7DC69BB

Checking 4 curation files...

❌ Found unresolved curation item references in Modules/ContentKit/Resources/Content/curations/subcurations/fine_motor_skills-EFBB68F0B3D84A32B08A688CC2F9B8F0.curation.yml
  - content/2/items/1: activity -> magic_card_belt_color_recognition-D3E24B95730848329B122769B077E65C
  - content/2/items/2: activity -> magic_card_screen_color_recognition-64C2CDF7DAA240CEB195F1BBE13941E3
  - content/2/items/3: activity -> magic_card_leka_emotion_recognition-6BFDE930EBA7462AAC828D09843D7747
  - content/2/items/4: activity -> magic_card_child_emotion_recognition-A40CA9F3F50A4FD58DB9FF40B7DC69BB

Checking 4 curation files...

✅ All curation files are valid!
```

### check_yaml_content_new_activities_unique_uuid
```
Check new_activity.yml files for unique uuid.............................Passed
```

### check_yaml_content_curriculums_unique_uuid
```
Check curriculum.yml files for unique uuid...............................Passed
```

### check_yaml_content_stories_unique_uuid
```
Check story.yml files for unique uuid....................................Passed
```

### check_yaml_content_cross_type_unique_uuid
```
Check content files for cross-type UUID collisions.......................Passed
```

### check_yaml_content_activities_assets
```
Check activity.asset.* files.............................................Passed
```

### check_yaml_definitions_skills
```
Check skills.yml.........................................................Passed
```

### check_yaml_definitions_tags
```
Check tags.yml...........................................................Passed
```

### check_yaml_definitions_authors
```
Check authors.yml........................................................Passed
```

---

## Issue Tally

| Severity | Count | Description |
|----------|-------|-------------|
| CRITICAL | 2 | Schema violations: `story` type not in JTD enum (stories curation + quiet_time subcuration) |
| WARNING | 21 | Unresolved references across 6 curation files (missing curricula, missing activities, missing subcuration) |
| INFO | 1 | Multi-hyphen name parsing caveat in mathematics subcuration |

**Files failing validation:** 2 (schema) + 6 (unresolved refs) = **8 curation files with issues**
**Unique missing items:**
- 9 missing curricula in `curriculums-2685B06A51324C31A255B50D8A2AD064`
- 1 missing curriculum in `mathematics-9D3BC84542E44614922FE450EC2F7F58`
- 2 missing curricula in `categorize_associate_organize-3B7D4928FF4B498F9DAA16FF50933979`
- 4 missing activities in `magic_card_content-E6AEC63DF38F467E9C9974931017E47A` (known gap)
- 4 missing activities in `fine_motor_skills-EFBB68F0B3D84A32B08A688CC2F9B8F0` (same known gap)
- 1 missing curation in `sandbox-4B476A0DFDC044B98DCBC631FF4EA27B`
- 6 invalid type in `stories-EA36F26CEE7A495B878EB1285AFBA4D3` (CRITICAL)
- 6 invalid type in `quiet_time-7A47BF7D73694FA9A364A256511EE809` (CRITICAL)
