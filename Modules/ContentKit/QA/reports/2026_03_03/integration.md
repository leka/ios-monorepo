# Wave 3 — Integration Audit Report

> Generated: 2026-03-03
> Auditor: Sisyphus QA Agent (task-15)
> Scope: `Modules/ContentKit/Resources/Content/`

---

## Directory Naming Audit

### Summary

**78 curriculum directories checked, 9 anomalies found across 8 unique directories.**

Anomaly breakdown:
- 3 directories missing `curriculum_` prefix (warning)
- 3 directories using deprecated `.curriculum` bundle suffix (warning)
- 2 directories whose name does not match their contained `.curriculum.yml` filename (warning)
- 1 directory with a hyphen in the name portion — `flower-petals` (info)
- 2 directories missing a `new_activities/` subdirectory (info)

### Findings

| Directory | Issue | Severity |
|-----------|-------|----------|
| `color_bingo-69760D1DA61849E3926E3A939BBEF0CE` | Missing `curriculum_` prefix | warning |
| `super_simon-C6EABAC161CD44C290B32202DFDCDAF6` | Missing `curriculum_` prefix | warning |
| `templates` | Not a content directory (contains template YML only, no UUID) | warning |
| `curriculum_find_ingredients_for_recipes-B477244ADFED4735BA1159A76E25001A.curriculum` | Uses deprecated `.curriculum` bundle suffix | warning |
| `curriculum_recognition_emotions_in_context-A135163C8D8646DE95D0854FD5E155EB.curriculum` | Uses deprecated `.curriculum` bundle suffix | warning |
| `curriculum_recognition_weather_and_time-1D8E1AB667DB40B199479D731EF96F2E.curriculum` | Uses deprecated `.curriculum` bundle suffix | warning |
| `curriculum_categorization_sorting_fruits_vegetables_basket-E6A322DC7A6E48518CED2CA2D3D2A595` | Dir name contains `curriculum_categorization_` prefix but YML name inside is `sorting_fruits_vegetables_basket-E6A322DC7A6E48518CED2CA2D3D2A595` (missing `curriculum_` in YML name) | warning |
| `curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1` | Dir uses hyphen `flower-petals`; YML inside is `curriculum_counting_flower_petals-...` (underscore). Dir name ≠ YML name | warning |
| `super_simon-C6EABAC161CD44C290B32202DFDCDAF6` | No `new_activities/` subdirectory | info |
| `templates` | No `new_activities/` subdirectory | info |
| `curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1` | Hyphen in name portion (`flower-petals`); all other dirs use underscores | info |

### Bonus: Stale/Broken Curation References

3 references in curation files point to UUIDs that do **not** match any known published content (dead references):

| Curation File | Stale Reference | Issue |
|---------------|-----------------|-------|
| `curriculums-2685B06A51324C31A255B50D8A2AD064.curation.yml` (line 35) | `curriculum_recognition_alphabet_letters_a_to_f-50DC12AA75AA4ED48928FBAFB73CA7EF` | UUID does not exist in any curriculum file |
| `curriculums-2685B06A51324C31A255B50D8A2AD064.curation.yml` (lines 379, 427) | `curriculum_recognition_cooked_fruits-723490A27448424EAFCB7D75444E0480` | Ghost UUID — published curriculum uses UUID `C0D2DAE8152F4CAE863EAEBF815354BA` |
| `sandbox-4B476A0DFDC044B98DCBC631FF4EA27B.curation.yml` (line 290) | `by_theme-F83E2947CE8F40D1B6B8798042F3D31A` | No matching curation file exists for this UUID |

Additionally, these name-mismatched references resolve by UUID but use inconsistent names (warning for content authoring):

| Curation Value (mismatched name) | Correct name (from YML `name:` field) | UUID |
|----------------------------------|---------------------------------------|------|
| `curriculum_christmas_memory-EFC444BBDEF24E08813FF472FFA5365D` | `curriculum_memory_christmas` | `EFC444BBDEF24E08813FF472FFA5365D` |
| `curriculum_alphabetical_order_a_to_f-F9A2F6E76AE449999B1F76AA7E2D2978` | `curriculum_alphabetical_order` | `F9A2F6E76AE449999B1F76AA7E2D2978` |
| `curriculum_order_by_size-1FAED1FF14134571849325B6EC9197B5` | `curriculum_order_by_size_animals` | `1FAED1FF14134571849325B6EC9197B5` |
| `curriculum_counting_flower-petals-3F83E1E0F3094DC787258B9CEEF227A1` | `curriculum_counting_flower_petals` | `3F83E1E0F3094DC787258B9CEEF227A1` |
| `magic_card_belt_color_recognition-D3E24B95730848329B122769B077E65C` | `magic_card_color_recognition_belt` | `D3E24B95730848329B122769B077E65C` |
| `magic_card_screen_color_recognition-64C2CDF7DAA240CEB195F1BBE13941E3` | `magic_card_color_recognition_screen` | `64C2CDF7DAA240CEB195F1BBE13941E3` |
| `magic_card_child_emotion_recognition-A40CA9F3F50A4FD58DB9FF40B7DC69BB` | `magic_card_emotion_recognition_child` | `A40CA9F3F50A4FD58DB9FF40B7DC69BB` |
| `magic_card_leka_emotion_recognition-6BFDE930EBA7462AAC828D09843D7747` | `magic_card_emotion_recognition_leka` | `6BFDE930EBA7462AAC828D09843D7747` |

---

## Orphaned Content Detection

> **Methodology:** Curation reference graph built from all 40 `.curation.yml` files
> (8 top-level + 32 subcurations). All `items[].value` fields extracted.
> Content is "orphaned" when its `name-UUID` identifier (from its YML `name:` field)
> does not appear in any curation's items.
>
> **Note:** Most orphaned activities are curriculum-member activities (e.g., `_2`, `_4`, `_6`
> difficulty variants). They are accessible to users via their parent curriculum, which IS
> referenced in curations. Direct curation reference is only required for standalone activities.
> Severity is `info` — orphaned content may be intentional.

### Summary

**368 published activities checked, 298 orphaned (81%)**
**77 published curricula checked, 1 orphaned (1%)**

### Orphaned Curricula

| Curriculum | Status | Notes |
|------------|--------|-------|
| `curriculum_find_ingredients_for_recipes-B477244ADFED4735BA1159A76E25001A` | published | Not referenced in any curation; directory also uses deprecated `.curriculum` suffix |

### Orphaned Activities

> 298 published activities not directly referenced in any curation.
> See the `.sisyphus/evidence/` directory in the repo root for raw backing data.
> Summary by topic group below.

| Topic Group | Orphaned Count | Example |
|-------------|---------------|---------|
| `alphabet_letters_sounds` | 20 | `alphabet_letters_sounds_1_1` through `_5_5` (all 5 series × 4 exercises) |
| `alphabetical_order` | 5 | `alphabetical_order_a_to_f`, `g_to_k`, `l_to_p`, `q_to_u`, `v_to_z` |
| `animal_recognition` (variants) | 18 | `_2`, `_4`, `_6` variants for farm/forest/insects/pets/sea/savannah |
| `animal_memory` | 3 | `1_pair`, `2_pairs`, `4_pairs` |
| `categorization_sort_through` (variants) | 6 | 3-category, functional-category variants |
| `categorization_sorting_fruits_vegetables` (variants) | 3 | `_2_two_choices`, `_3_three_choices`, `_4_four_choices` |
| `color_bingo` | 3 | `color_bingo_4`, `_5`, `_6` |
| `counting_candies` | 2 | `from_1_to_5`, `from_5_to_10` |
| `counting_flower_petals` | 2 | `from_10_to_15`, `from_15_to_20` |
| `counting_robot` | 3 | `animals`, `fruits`, `musical_instruments` |
| `find_ingredients_for_recipes` | 2 | `with_one_intruder`, `without_intruder` |
| `fruits_and_vegetables_generalization` | 2 | `with_3_intruders`, `without_intruder` |
| `generalization_fruits_robot` | 4 | `fruits_robot_1/2`, `vegetables_robot_1/2` |
| `magic_card` (variants) | 4 | `color_recognition_belt/screen`, `emotion_recognition_child/leka` |
| `memory_christmas` | 3 | `1_pair`, `2_pairs`, `4_pairs` |
| `order_by_size_animals` | 9 | bear, cow, dolphin, fish, giraffe, koala, ladybug, rabbit, snail |
| `order_by_size_different_animals` | 1 | single variant |
| `ordering_of_life_stages` | 2 | `boy`, `girl` |
| `ordering_steps_of_session_with_leka` | 3 | `_2`, `_3`, `_4` |
| `ordering_steps_to_bake_a_cake` | 3 | `_3`, `_4`, `_6` |
| `receptive_language` (all) | 14 | identify_familiar_nouns, ing_verbs, number_quantity, objects_by_color, by_function, opposites, positional_concepts |
| `recognition_alphabet_letters` (variants) | 15 | `_2`, `_4`, `_6` for all 5 series |
| `recognition_basic_physiological_needs` | 3 | 1/2/4 images |
| `recognition_body_parts` (variants) | 3 | `_2`, `_4`, `_6` |
| `recognition_christmas` (variants) | 2 | `_2`, `_4` |
| `recognition_cooked_fruits` (variants) | 3 | 2/4/6 images |
| `recognition_cooked_vegetables` (variants) | 3 | 2/4/6 images |
| `recognition_digital_constellations` (variants) | 3 | dice_numbers, dice, objects |
| `recognition_emotions_drawings` (all variants) | 22 | all moussa/oscar/zoe/multi-character variants |
| `recognition_emotions_generalization` | 6 | 2/3-type × 3/4/6 images |
| `recognition_emotions_pictograms` (variants) | 3 | `_2_leka`, `_3_leka`, `_4_leka` |
| `recognition_emotions_pictures` (all variants) | 22 | all ladislas/lucie/yann/multi-person variants |
| `recognition_emotions_robot` (variants) | 9 | generalization + image/picture variants |
| `recognition_family_members` (variants) | 3 | `_2`, `_4`, `_6` |
| `recognition_garden_items` (variants) | 3 | `_2`, `_4`, `_6` |
| `recognition_halloween` (variants) | 2 | `_2`, `_4` |
| `recognition_modes_of_transportation` (variants) | 3 | `_2`, `_4`, `_6` |
| `recognition_professions_drawings` | 6 | 1–6 images |
| `recognition_seaside_holidays` (variants) | 5 | `_2` through `_6` |
| `recognition_sounds_animals` | 6 | 1–6 images |
| `recognition_sounds_emotions` | 16 | all person+count combinations |
| `recognition_sounds_musical_instruments` | 6 | 1–6 images |
| `recognition_sports_drawings` | 6 | 1–6 images |
| `recognition_the_ice_floe` (variants) | 2 | `_2`, `_4` |
| `recognition_winter_holidays` (variants) | 3 | `_2`, `_4`, `_6` |
| `shape_recognition` (variants) | 6 | 2/4-images for plain, filled/unfilled, identical |
| `sort_objects_by_location` (variants) | 6 | 1/2 zones × 1/2/4/6 choices |
| `sort_sweet_and_salty` (variants) | 4 | 1/2 zones × 1/2/4 choices |
| `visual_discrimination_shapes_and_colors` | 4 | shapes/colors × 2/4 images |
| `weather_with_leka` | 3 | `_1`, `_2`, `_3` |

---

## Key Findings

1. **6 warning-level naming anomalies** in curriculum directories (3 missing prefix, 3 using deprecated `.curriculum` suffix).
2. **2 warning-level name-mismatch** directories where dir name ≠ YML `name:` field — this may cause curation resolution failures at runtime if the system ever resolves by name rather than UUID.
3. **3 dead curation references** (ghost UUIDs / missing subcuration): `curriculum_recognition_alphabet_letters_a_to_f-50DC12AA…`, `curriculum_recognition_cooked_fruits-723490A2…`, `by_theme-F83E2947…` — these will silently fail to resolve at runtime.
4. **4 curation name-mismatches** (same UUID, different human-readable name) — functional but causes content-authoring confusion.
5. **1 orphaned published curriculum**: `curriculum_find_ingredients_for_recipes-B477244A…` — not linked from any curation; coincides with the deprecated `.curriculum` suffix issue on its directory.
6. **298 orphaned published activities** — expected pattern; these are curriculum-member variants (difficulty levels `_2`, `_4`, `_6`) accessible only through parent curricula which ARE curation-linked. Not actionable unless standalone accessibility is desired.
