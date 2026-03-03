# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

## What the QA Audit Checks

The content QA audit validates three areas:

1. **Structural validation** — YAML schema compliance, UUID uniqueness, locale completeness (crash risk if missing), asset references
2. **Text quality review** — Bilingual text (fr_FR + en_US) for typos, encoding errors, placeholder text, untranslated content, truncated strings, empty fields
3. **Cross-reference integrity** — Curation items pointing to non-existent curricula/activities/stories; orphaned content not reachable via any curation

## How to Run Automated Checks

Run a single hook:

```bash
pre-commit run check_yaml_content_new_activities --all-files
```

Run all content hooks:

```bash
pre-commit run --all-files
```

**Note:** Activity hooks can be slow on large content directories. For rapid iteration, run only the hook targeting your file type.

## What Needs Manual Review

Automated checks do not cover text quality. Reviewers should flag these 7 issue types:

1. **Typos** — Spelling errors in titles, descriptions, instructions
2. **Encoding errors** — Mojibake, invalid UTF-8, corrupted characters
3. **Placeholder text** — Lorem ipsum, "TODO", "FIXME", "XXX", "temp"
4. **Empty fields** — Missing required l10n details (title, subtitle, description)
5. **Untranslated content** — Text in one locale only (e.g., French title with English description)
6. **Truncated strings** — Text cut off mid-word or mid-sentence
7. **Broken formatting** — Misaligned line breaks, unescaped special characters, malformed markdown

**Do NOT flag:**
- Disability-domain terminology (e.g., "handicap", "special needs") — intentional and appropriate
- Style differences between authors — acceptable variation

## Severity Definitions

| Severity | Definition | Examples |
|----------|-----------|----------|
| critical | Crash or content loss risk | Missing locale, invalid UUID, schema violation, broken curation reference |
| warning | Inconsistency or broken reference | Typo, encoding error, orphaned activity, mismatched asset |
| info | Style or formatting issue | Inconsistent capitalization, extra whitespace, minor formatting |

## Hook Inventory

| Hook ID | Targets | What It Checks |
|---------|---------|----------------|
| check_yaml_definitions_avatars | avatars.yml | Non-unique IDs, schema validation, filename/image consistency |
| check_yaml_definitions_professions | professions.yml | Non-unique IDs, schema validation, entry sorting |
| check_yaml_definitions_authors | authors.yml | Non-unique IDs, schema validation, entry sorting |
| check_yaml_definitions_skills | skills.yml | Non-unique IDs, schema validation, entry sorting |
| check_yaml_definitions_robot_assets | robot_assets.yml | Non-unique IDs, schema validation, entry sorting |
| check_yaml_definitions_tags | tags.yml | Non-unique IDs, schema validation, entry sorting |
| check_yaml_content_new_activities | *.new_activity.yml | UUID/filename consistency, schema validation |
| check_yaml_content_new_activities_unique_uuid | *.new_activity.yml | UUID uniqueness across all new activities |
| check_yaml_content_activities_unique_uuid | *.activity.yml | UUID uniqueness across all legacy activities |
| check_yaml_content_activities_assets | *.activity.asset.* | Asset file duplicates |
| check_yaml_content_curriculums | *.curriculum.yml | UUID/filename consistency, schema validation |
| check_yaml_content_curriculums_unique_uuid | *.curriculum.yml | UUID uniqueness across all curriculums |
| check_yaml_content_curations | *.curation.yml | UUID/filename consistency, schema validation, item reference integrity |
| check_yaml_content_stories | *.story.yml | UUID/filename consistency, schema validation |
| check_yaml_content_stories_unique_uuid | *.story.yml | UUID uniqueness across all stories |
| check_yaml_content_cross_type_unique_uuid | *.new_activity.yml, *.curriculum.yml, *.story.yml, *.curation.yml | UUID collisions across all content types |
