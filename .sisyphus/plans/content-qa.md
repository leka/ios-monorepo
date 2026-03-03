# Content QA Audit — Comprehensive YAML Content Quality Assurance

## TL;DR

> **Quick Summary**: Systematic quality audit of all 386 v2 activities, 78 curriculums, 40 curations, 6 stories, and 6 definition files in the Leka educational content system. Run existing validation tooling first to establish a baseline, then focus agent effort on the gaps: locale completeness (crash risk), curation reference integrity (unvalidated), and bilingual text quality review (no existing tooling covers this).
>
> **Deliverables**:
> - Wave 1 report: Structural validation findings (YAML validity, schema compliance, cross-references, locale completeness)
> - Wave 2 report: Text quality findings (typos, encoding errors, placeholder text, untranslated content in both FR and EN)
> - Wave 3 report: Integration findings (curation references, orphaned content, asset integrity)
> - Master summary: Combined findings with severity counts and recommended fix priority
>
> **Estimated Effort**: Large (500+ YAML files across 4 content types)
> **Parallel Execution**: YES — 3 waves, up to 8 tasks per wave
> **Critical Path**: Task 1 (run existing validators) → Task 2-7 (gap checks) → Task 8-13 (text review) → Task 14-16 (integration) → Final Verification

---

## Context

### Original Request
Comprehensive QA pass across all YAML educational content files. This is the first priority in a 4-step roadmap: QA → Expert Educational Review → Spanish Translation → New Content Generation.

### Interview Summary
**Key Discussions**:
- Only v2 activity format (`.new_activity.yml`) matters; v1 (`.activity.yml`) is deprecated and will be removed
- Content targets people with broad disabilities (all ages, focus developmental age 0-6), created by special education professionals (éducateurs spécialisés, psychomotriciens, orthophonistes, OTs)
- All content is bilingual `fr_FR` + `en_US`
- QA is report-only — no auto-fixing, produce structured findings for human review
- French text was written by domain professionals; English text quality varies

**Research Findings**:
- 48 skills defined, 34 used (71%), 15 skills with zero content
- Heavy on `touchToSelect` interface, limited variety in other interfaces
- Some curriculums have only 1-2 activities (insufficient for learning progression)

### Metis Review
**Critical Findings** (addressed in plan):
1. **Silent failure model**: ContentKit.swift silently drops files that fail YAML decoding — content disappears without error
2. **`fatalError()` on missing locale**: If any l10n array is missing `en_US` or `fr_FR`, the app CRASHES at runtime. Existing tools do NOT check this.
3. **Existing validation tooling covers ~80%** of structural checks via pre-commit hooks in `Tools/Hooks/`. No need to re-implement.
4. **No curation validation exists**: No JTD schema, no pre-commit hook for `.curation.yml` files
5. **Directory naming inconsistencies**: 3 dirs use `.curriculum` bundle suffix, 2 lack `curriculum_` prefix, 1 has hyphenated name breaking UUID parser

**Identified Gaps** (incorporated):
- Locale completeness check is the #1 missing validation (crash risk)
- Curation item reference validation doesn't exist at all
- Author enum in JTD schema is hardcoded to 3 values
- `discoverLeka` interface missing from JTD schema but valid in Swift
- Text quality review has zero automated coverage

---

## Work Objectives

### Core Objective
Produce a comprehensive, severity-graded QA report covering all published v2 content files, identifying structural errors (that cause silent content loss or crashes), consistency issues, and text quality problems in both French and English.

### Concrete Deliverables
- `qa-reports/wave-1-structural.md` — Structural validation findings
- `qa-reports/wave-2-text-quality.md` — Text quality findings (FR + EN)
- `qa-reports/wave-3-integration.md` — Integration and cross-reference findings
- `qa-reports/master-summary.md` — Combined report with severity counts and fix priorities

### Definition of Done
- [ ] All 4 report files exist with structured findings
- [ ] Every finding is severity-graded: `critical` (crash/content loss), `warning` (inconsistency), `info` (style)
- [ ] Zero content files were modified (audit-only, no fixes)
- [ ] Master summary includes total counts per severity per content type

### Must Have
- Locale completeness check on ALL content files (crash-risk detection)
- Run existing pre-commit validators as baseline (not reinvent)
- Text quality check in BOTH fr_FR and en_US for all content
- Curation item reference validation (no existing tooling)
- Severity grading on every finding

### Must NOT Have (Guardrails)
- **NO auto-fixing of any content** — this is a report-only audit
- **NO modifications to Swift code, Python scripts, JTD schemas, or non-content files**
- **NO validation of v1 `.activity.yml` files** — but DO check if any curriculum still references v1-only activities
- **NO pedagogical rewrites or educational quality judgments** — only flag typos, encoding errors, placeholders, untranslated text
- **NO flagging of French disability-domain terminology** as errors (e.g., `personne accompagnée`, `aidant`, `pictogrammes`, `constellations digitales` are correct)
- **NO flagging of text style differences between curriculums** — different authors may have different writing styles
- **NO creation of new content, schema changes, or translations**

---

## Verification Strategy (MANDATORY)

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed. No exceptions.

### Test Decision
- **Infrastructure exists**: YES (pre-commit hooks + JTD schemas)
- **Automated tests**: None (this is an audit producing reports, not code)
- **Framework**: N/A — validation via existing Python scripts + content scanning

### QA Policy
Every task produces a structured report section. Verification = report exists with expected sections and finding counts. Evidence = the report files themselves.

- **Structural checks**: Run existing Python validators via Bash, capture output
- **Gap checks**: Use Grep/Read tools to scan YAML files for missing fields
- **Text quality**: Read each file, check l10n text fields for issues
- **Integration**: Cross-reference IDs between curations → content files

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Structural Validation — run existing tools + check gaps):
├── Task 1: Run existing pre-commit validators on ALL content [quick]
├── Task 2: Locale completeness audit — activities [deep]
├── Task 3: Locale completeness audit — curriculums + stories [unspecified-high]
├── Task 4: Curation schema & reference validation [unspecified-high]
├── Task 5: Directory naming & structural anomaly audit [quick]
├── Task 6: Cross-type UUID uniqueness check [quick]
├── Task 7: Definition files integrity check [quick]

Wave 2 (Text Quality Review — parallelized by curriculum batches):
├── Task 8: Text quality — curriculums batch A (1-26) + their activities [deep]
├── Task 9: Text quality — curriculums batch B (27-52) + their activities [deep]
├── Task 10: Text quality — curriculums batch C (53-78) + their activities [deep]
├── Task 11: Text quality — standalone activities + templates + gamepads [unspecified-high]
├── Task 12: Text quality — stories (all 6) [unspecified-high]
├── Task 13: Text quality — curations (all 40) + definitions [unspecified-high]

Wave 3 (Integration & Cross-Reference Checks):
├── Task 14: Curation → content reference integrity [deep]
├── Task 15: Curriculum → activity reference integrity [deep]
├── Task 16: Asset reference & orphaned content audit [unspecified-high]

Wave 4 (Report Compilation):
├── Task 17: Compile master summary report [unspecified-high]

Wave FINAL (Independent Review — 4 parallel):
├── Task F1: Plan compliance audit [oracle]
├── Task F2: Report completeness review [unspecified-high]
├── Task F3: Sample spot-check verification [deep]
├── Task F4: Scope fidelity check [deep]

Critical Path: Task 1 → Tasks 2-7 → Tasks 8-13 → Tasks 14-16 → Task 17 → F1-F4
Parallel Speedup: ~65% faster than sequential
Max Concurrent: 7 (Wave 1)
```

### Dependency Matrix

| Task | Depends On | Blocks |
|------|-----------|--------|
| 1 | — | 2-7, 8-16 |
| 2 | 1 | 17 |
| 3 | 1 | 17 |
| 4 | 1 | 14, 17 |
| 5 | 1 | 17 |
| 6 | 1 | 17 |
| 7 | 1 | 17 |
| 8 | 1 | 17 |
| 9 | 1 | 17 |
| 10 | 1 | 17 |
| 11 | 1 | 17 |
| 12 | 1 | 17 |
| 13 | 1 | 17 |
| 14 | 4 | 17 |
| 15 | 1 | 17 |
| 16 | 1 | 17 |
| 17 | 2-16 | F1-F4 |
| F1-F4 | 17 | — |

### Agent Dispatch Summary

- **Wave 1**: **7 tasks** — T1 → `quick`, T2 → `deep`, T3 → `unspecified-high`, T4 → `unspecified-high`, T5 → `quick`, T6 → `quick`, T7 → `quick`
- **Wave 2**: **6 tasks** — T8-T10 → `deep`, T11-T13 → `unspecified-high`
- **Wave 3**: **3 tasks** — T14-T15 → `deep`, T16 → `unspecified-high`
- **Wave 4**: **1 task** — T17 → `unspecified-high`
- **FINAL**: **4 tasks** — F1 → `oracle`, F2 → `unspecified-high`, F3 → `deep`, F4 → `deep`

---

## TODOs

- [ ] 1. Run Existing Pre-Commit Validators on ALL Content

  **What to do**:
  - Run ALL existing Python validation scripts from `Tools/Hooks/` against the full content directory (not just staged files)
  - Scripts to run: `check_yaml_content_new_activities.py`, `check_yaml_content_curriculums.py`, `check_yaml_content_stories.py`, `check_yaml_content_activities_unique_uuid.py`, `check_yaml_content_curriculums_unique_uuid.py`, `check_yaml_content_stories_unique_uuid.py`, `check_yaml_content_activities_assets.py`
  - Also run definition validators: `check_yaml_definitions_skills.py`, `check_yaml_definitions_tags.py`, `check_yaml_definitions_authors.py`
  - Capture ALL output (stdout + stderr) into `qa-reports/wave-1-existing-validators.md`
  - Categorize findings by severity: `critical` (would cause content to silently fail loading), `warning` (inconsistency), `info` (style)
  - Note: These scripts may need the content directory path as argument — inspect each script's `__main__` to determine invocation

  **Must NOT do**:
  - Do NOT modify any content files to fix issues
  - Do NOT modify the validator scripts themselves
  - Do NOT run v1-specific validators (`check_yaml_content_activities.py` targets v1 — skip it)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Running existing scripts and capturing output — straightforward shell execution
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `playwright`: No browser interaction needed
    - `git-master`: No git operations needed

  **Parallelization**:
  - **Can Run In Parallel**: NO (must complete first to establish baseline)
  - **Parallel Group**: Wave 1 lead task
  - **Blocks**: Tasks 2-16
  - **Blocked By**: None

  **References**:

  **Pattern References**:
  - `Tools/Hooks/check_yaml_content_new_activities.py` — Main v2 activity validator. Inspect `__main__` block for how to pass content directory path. This validates: UUID format, filename-UUID match, name-filename match, required fields, skills/tags cross-refs, icon existence, asset existence
  - `Tools/Hooks/check_yaml_content_curriculums.py` — Curriculum validator. Checks activity references, UUID, naming
  - `Tools/Hooks/check_yaml_content_stories.py` — Story validator
  - `Tools/Hooks/check_yaml_uuid_uniqueness.py` — Cross-type UUID uniqueness
  - `Tools/Hooks/modules/base_validator.py` — Base validation class, understand error/warning reporting format
  - `Tools/Hooks/modules/content_validators.py` — Content-specific validation functions
  - `Tools/Hooks/modules/definitions.py` — How definitions (skills, tags, authors) are loaded for cross-referencing

  **External References**:
  - `.pre-commit-config.yaml` — Shows how hooks are normally invoked, what arguments they expect

  **WHY Each Reference Matters**:
  - The validator scripts are the existing QA tooling. Running them first prevents duplicating ~80% of structural checks. Their output format determines how to parse and categorize findings.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All validators run successfully and output is captured
    Tool: Bash
    Preconditions: Python 3 available, PyYAML installed
    Steps:
      1. Run: python3 Tools/Hooks/check_yaml_content_new_activities.py (with correct args)
      2. Capture exit code and output
      3. Repeat for each validator script
      4. Write captured output to qa-reports/wave-1-existing-validators.md
    Expected Result: File exists with validator output, each script's results clearly labeled
    Failure Indicators: Script crashes with ImportError, or file is empty
    Evidence: .sisyphus/evidence/task-1-validators-run.txt

  Scenario: Validator failure handling — script not found or dependency missing
    Tool: Bash
    Preconditions: None
    Steps:
      1. Attempt to run each validator
      2. If any fails with ImportError or FileNotFoundError, document the error
      3. Continue with remaining validators (don't stop on first failure)
    Expected Result: All validators attempted, failures documented with error messages
    Evidence: .sisyphus/evidence/task-1-validator-errors.txt
  ```

  **Evidence to Capture:**
  - [ ] task-1-validators-run.txt — Full output of all validators
  - [ ] task-1-validator-errors.txt — Any scripts that failed to run

  **Commit**: NO (report only)

- [ ] 2. Locale Completeness Audit — v2 Activities (CRASH RISK)

  **What to do**:
  - Scan ALL 386 v2 activity files (`*.new_activity.yml`) across `curriculums/*/new_activities/` and `newActivities/`
  - For EACH file, verify the `l10n:` array contains entries for BOTH `fr_FR` AND `en_US`
  - For EACH locale entry, verify these fields exist and are non-empty: `title`, `subtitle`, `short_description`, `description`
  - Also check exercise-level `instructions:` arrays have both locales where present
  - Also check `action.value.value:` speech utterances have both locales where present
  - Severity: **critical** for missing locale entirely (causes `fatalError()` crash), **warning** for empty/missing text fields within an existing locale
  - Write findings to a structured section for inclusion in `qa-reports/wave-1-structural.md`
  - Format: `| File | Issue | Severity | Details |`

  **Must NOT do**:
  - Do NOT add missing locales or fix empty fields
  - Do NOT check v1 `.activity.yml` files
  - Do NOT validate the *content quality* of text (that's Wave 2)

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: 386 files to scan systematically, needs thorough file-by-file inspection without missing any
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `playwright`: No browser interaction

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 3, 4, 5, 6, 7)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1 (need baseline to avoid duplicate reporting)

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curriculums/curriculum_recognition_body_parts-80761A1D62BF4C6980BF20E7D9BE52B8/new_activities/recognition_body_parts_1-756B84801C32483FABEA6E5BC5DF7081.new_activity.yml` — Example v2 activity file. Check its l10n structure as the canonical reference for what a complete activity looks like.

  **API/Type References**:
  - `Modules/ContentKit/Sources/Content/_NewSystem/Activity/Activity.swift` — The `details(in:)` method calls `fatalError()` when locale is missing. This is WHY locale completeness is critical.
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Full activity schema documentation, especially the l10n section

  **WHY Each Reference Matters**:
  - The Activity.swift crash path proves missing locales are critical severity. The AGENTS.md schema tells the agent exactly which fields to check in the l10n structure.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All v2 activity files scanned for locale completeness
    Tool: Bash
    Preconditions: Content directory exists at Modules/ContentKit/Resources/Content/
    Steps:
      1. Count all .new_activity.yml files: find Modules/ContentKit/Resources/Content -name "*.new_activity.yml" | wc -l
      2. Assert count = 386 (or document if different)
      3. For each file, grep for "locale: fr_FR" and "locale: en_US" in l10n sections
      4. Flag any file where either locale is missing
      5. Write findings table to qa-reports section
    Expected Result: Report section listing any files with missing locales, with count header "Scanned: N files, Critical: N, Warning: N"
    Failure Indicators: Report shows 0 files scanned, or count doesn't match expected
    Evidence: .sisyphus/evidence/task-2-locale-activities.md

  Scenario: Empty text fields detected within existing locales
    Tool: Bash / Read
    Preconditions: Files have l10n entries
    Steps:
      1. For each l10n entry, check title, subtitle, description, short_description
      2. Flag empty strings (""), whitespace-only, or missing fields
      3. Include file path and locale in finding
    Expected Result: List of files with empty critical text fields
    Evidence: .sisyphus/evidence/task-2-empty-fields.md
  ```

  **Evidence to Capture:**
  - [ ] task-2-locale-activities.md — Locale completeness findings for all v2 activities
  - [ ] task-2-empty-fields.md — Empty/missing text field findings

  **Commit**: NO (report only)

- [ ] 3. Locale Completeness Audit — Curriculums + Stories

  **What to do**:
  - Scan all 78 curriculum files (`*.curriculum.yml`) for locale completeness
  - Scan all 6 story files (`*.story.yml`) for locale completeness
  - For curriculums: verify `l10n:` has both `fr_FR` and `en_US` with non-empty `title`, `subtitle`, `abstract`, `description`
  - For stories: verify `l10n:` at top level AND `pages[].l10n[]` at page level both have both locales
  - Stories have additional text in `pages[].l10n[].items[].payload.text` — verify these are non-empty for both locales
  - Severity: **critical** for missing locale (crash risk), **warning** for empty fields
  - Write findings to structured section for `qa-reports/wave-1-structural.md`

  **Must NOT do**:
  - Do NOT fix any content
  - Do NOT check text quality (that's Wave 2)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: 84 files total (78 curriculums + 6 stories), moderate scope but needs careful checking of nested page structures in stories
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 4, 5, 6, 7)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curriculums/curriculum_recognition_body_parts-80761A1D62BF4C6980BF20E7D9BE52B8/curriculum_recognition_body_parts-80761A1D62BF4C6980BF20E7D9BE52B8.curriculum.yml` — Example curriculum file with l10n structure
  - `Modules/ContentKit/Resources/Content/stories/hanna_meets_leka-FF7618528E194E8CB3A6950E08562D16.story.yml` — Example story with nested page l10n

  **API/Type References**:
  - `Modules/ContentKit/Sources/Content/_NewSystem/Curriculum/Curriculum.swift` — Curriculum `details(in:)` also calls fatalError on missing locale
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Curriculum and Story schema documentation

  **WHY Each Reference Matters**:
  - Curriculum.swift confirms the same fatalError crash path exists for curriculums. Stories have a more complex nested l10n structure (top-level + per-page) that needs careful traversal.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All curriculums scanned for locale completeness
    Tool: Bash
    Preconditions: Content directory exists
    Steps:
      1. Count curriculum files: find ... -name "*.curriculum.yml" | wc -l → expect 78
      2. For each, verify both locales present in l10n array
      3. Check required fields non-empty per locale
    Expected Result: Report section with "Scanned: 78 curriculums, Critical: N, Warning: N"
    Evidence: .sisyphus/evidence/task-3-locale-curriculums.md

  Scenario: Story page-level l10n completeness
    Tool: Read
    Preconditions: 6 story files exist
    Steps:
      1. Open each story file
      2. Check top-level l10n for both locales
      3. For each page, check page-level l10n for both locales
      4. Check text content is non-empty in both locales
    Expected Result: Per-story report listing any missing page-level locales
    Evidence: .sisyphus/evidence/task-3-locale-stories.md
  ```

  **Commit**: NO (report only)

- [ ] 4. Curation Schema & Reference Validation

  **What to do**:
  - Scan all 40 curation files (`*.curation.yml`) — 8 top-level + ~30 subcurations + 2 others
  - No JTD schema exists for curations — perform manual structural validation:
    - Required fields: `uuid`, `icon`, `color`, `l10n` (both locales), `content` array
    - Each content section: `component` (valid type), `items` array
    - Each item: `value` (name-UUID format), `type` (curriculum | activity | curation)
  - Validate component types against known values: `carousel`, `horizontal_curriculum_grid`, `horizontal_activity_grid`, `horizontal_curriculum_list`, `horizontal_activity_list`, `horizontal_curation_list`, `vertical_curriculum_grid`, `vertical_activity_grid`, `vertical_curation_grid`
  - Check that the `color` field is a valid hex format (e.g., `0xFFEEFF`)
  - Check locale completeness (both `fr_FR` and `en_US` with non-empty `title`)
  - Write findings to structured section for `qa-reports/wave-1-structural.md`

  **Must NOT do**:
  - Do NOT create a JTD schema (that's a separate task)
  - Do NOT check whether referenced items actually exist (that's Task 14)
  - Do NOT modify curation files

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: 40 files, no existing validation — agent must define and apply checks from scratch based on schema documentation
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3, 5, 6, 7)
  - **Blocks**: Tasks 14, 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curations/home-F4E2C104C09E436CB80A87749CE62DDF.curation.yml` — Example top-level curation
  - `Modules/ContentKit/Resources/Content/curations/subcurations/animals-0609CB09299847E581F6E191796499B4.curation.yml` — Example subcuration

  **API/Type References**:
  - `Modules/ContentKit/Sources/Content/_NewSystem/Categories/Category+Curation.swift` — Swift model decoding curations, shows expected structure
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Curation schema and component type documentation

  **WHY Each Reference Matters**:
  - Since no JTD schema exists, the Swift decoder and AGENTS.md are the only source of truth for what a valid curation looks like. The agent needs both to define correct validation rules.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All 40 curations validated against expected structure
    Tool: Bash / Read
    Preconditions: Curation files exist
    Steps:
      1. Count curation files: find ... -name "*.curation.yml" | wc -l → expect 40
      2. For each, check required fields exist and are non-empty
      3. Validate component types against known enum
      4. Validate color hex format
      5. Check l10n locale completeness
    Expected Result: Report section with "Scanned: 40 curations, Critical: N, Warning: N, Info: N"
    Evidence: .sisyphus/evidence/task-4-curation-validation.md

  Scenario: Invalid component type detection
    Tool: Grep
    Preconditions: Curation files exist
    Steps:
      1. Extract all component values from all curation files
      2. Compare against known valid types list
      3. Flag any unknown component types
    Expected Result: List of any curations using invalid component types (expect 0 or document all)
    Evidence: .sisyphus/evidence/task-4-invalid-components.md
  ```

  **Commit**: NO (report only)

- [ ] 5. Directory Naming & Structural Anomaly Audit

  **What to do**:
  - Audit all 78 curriculum directories for naming consistency:
    - Flag dirs using `.curriculum` bundle suffix (expected: 3 known — `curriculum_recognition_weather_and_time`, `curriculum_recognition_emotions_in_context`, `curriculum_find_ingredients_for_recipes`)
    - Flag dirs missing `curriculum_` prefix (expected: 2 known — `super_simon`, `color_bingo`)
    - Flag dirs with hyphens in name portion (before UUID separator) — known: `curriculum_counting_flower-petals`
    - Flag dirs where directory name doesn't match contained `.curriculum.yml` filename — known: `curriculum_categorization_sorting_fruits_vegetables_basket` dir contains `sorting_fruits_vegetables_basket` file
    - Flag curriculum dirs that have NO `new_activities/` subdirectory — known: `curriculum_magic_card`
  - Check that EVERY curriculum directory containing a `.curriculum.yml` also contains a `new_activities/` subdirectory (or document the exception)
  - Check that there are no orphaned directories (directories in `curriculums/` without a `.curriculum.yml` file)
  - Write findings to structured section for `qa-reports/wave-1-structural.md`
  - Separate findings into: "known anomalies" (documented above) vs "new findings"

  **Must NOT do**:
  - Do NOT rename or restructure any directories
  - Do NOT move files

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Directory-level checks only, no file content parsing needed — fast shell commands
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3, 4, 6, 7)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curriculums/` — The parent directory to audit. List all subdirectories and check naming patterns.

  **WHY Each Reference Matters**:
  - Directory naming anomalies can cause the content loader to miss files if it depends on naming conventions. The known anomalies should be confirmed still exist and any NEW ones should be flagged.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All curriculum directories audited for naming consistency
    Tool: Bash
    Preconditions: Curriculums directory exists
    Steps:
      1. List all directories: ls -d Modules/ContentKit/Resources/Content/curriculums/*/
      2. Check each for: .curriculum suffix, curriculum_ prefix, hyphens in name, matching .curriculum.yml
      3. Check for new_activities/ subdirectory existence
    Expected Result: Report listing all anomalies, separated into "Known" and "New Findings"
    Evidence: .sisyphus/evidence/task-5-directory-naming.md

  Scenario: Orphaned directories detection
    Tool: Bash
    Preconditions: Curriculums directory exists
    Steps:
      1. For each directory in curriculums/, check if it contains a .curriculum.yml file
      2. Flag any directory without one (excluding templates/)
    Expected Result: List of orphaned directories (expect 0 or document)
    Evidence: .sisyphus/evidence/task-5-orphaned-dirs.md
  ```

  **Commit**: NO (report only)

- [ ] 6. Cross-Type UUID Uniqueness Check

  **What to do**:
  - Extract the `uuid:` field from EVERY content YAML file across ALL types:
    - All `*.new_activity.yml` (386 files)
    - All `*.curriculum.yml` (78 files)
    - All `*.story.yml` (6 files)
    - All `*.curation.yml` (40 files)
  - Check for UUID collisions ACROSS content types (a curriculum and an activity sharing the same UUID)
  - Check for UUID collisions WITHIN each content type
  - Validate UUID format: must be exactly 32 uppercase hex characters `[0-9A-F]{32}` with no hyphens
  - Also check that each file's UUID matches the UUID in its filename
  - Note: The existing `check_yaml_uuid_uniqueness.py` may already do within-type checks — focus on CROSS-TYPE uniqueness which is likely not covered
  - Write findings to structured section for `qa-reports/wave-1-structural.md`

  **Must NOT do**:
  - Do NOT fix UUID mismatches
  - Do NOT generate new UUIDs

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Straightforward grep + sort + uniq pipeline across files
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3, 4, 5, 7)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Tools/Hooks/check_yaml_uuid_uniqueness.py` — Existing within-type UUID checker. Read it to understand what it already covers vs what gaps remain.
  - `Tools/Hooks/modules/uuid_checker.py` — UUID validation utility module

  **WHY Each Reference Matters**:
  - Understanding existing UUID checks prevents duplication. The cross-type check (activity UUID = curriculum UUID) is the gap to fill.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: Cross-type UUID uniqueness verified
    Tool: Bash
    Preconditions: All YAML content files exist
    Steps:
      1. Extract uuid field from all *.new_activity.yml, *.curriculum.yml, *.story.yml, *.curation.yml
      2. Sort all UUIDs, check for duplicates: sort | uniq -d
      3. For any duplicate, identify which files share it
    Expected Result: Report listing any cross-type UUID collisions (expect 0)
    Evidence: .sisyphus/evidence/task-6-uuid-uniqueness.md

  Scenario: UUID format validation
    Tool: Bash (grep)
    Preconditions: UUID field exists in all files
    Steps:
      1. Extract uuid field from each file
      2. Validate against regex: ^[0-9A-F]{32}$
      3. Flag any non-conforming UUIDs (lowercase, wrong length, hyphens)
    Expected Result: List of files with malformed UUIDs
    Evidence: .sisyphus/evidence/task-6-uuid-format.md
  ```

  **Commit**: NO (report only)

- [ ] 7. Definition Files Integrity Check

  **What to do**:
  - Validate all 6 definition files in `Modules/ContentKit/Resources/Content/definitions/`:
    - `skills.yml` — Check all skill IDs are valid, hierarchical paths use `/`, no duplicates, YAML header present
    - `tags.yml` — Check all tag IDs are valid, no duplicates, YAML header present
    - `authors.yml` — Check all author entries have required fields, YAML header present
    - `activity_types.yml` — Validate contains `one_on_one` and `group`
    - `hmi.yml` — Validate contains expected mediums: `robot`, `magic_cards`, `tablet_robot`, `tablet`
    - `robot_assets.yml` — Validate hex ID format (`0x0001` through `0x00DB`), check for duplicates
  - Cross-reference: check that EVERY skill referenced in content files exists in `skills.yml`
  - Cross-reference: check that EVERY tag referenced in content files exists in `tags.yml`
  - Cross-reference: check that EVERY author referenced in content files exists in `authors.yml`
  - Note: existing validators likely cover skills and tags cross-refs — focus on confirming their output and checking authors (JTD only hardcodes 3 author values)
  - Write findings to structured section for `qa-reports/wave-1-structural.md`

  **Must NOT do**:
  - Do NOT add/remove skills, tags, or authors
  - Do NOT modify definition files

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: 6 small files to validate + cross-reference checks that can leverage grep
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3, 4, 5, 6)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/definitions/skills.yml` — Hierarchical skill definitions with subskill paths
  - `Modules/ContentKit/Resources/Content/definitions/authors.yml` — Author profiles. The JTD schema only knows 3 authors — check if more exist
  - `Tools/Hooks/check_yaml_definitions_skills.py` — Existing skills validator
  - `Tools/Hooks/check_yaml_definitions_tags.py` — Existing tags validator
  - `Tools/Hooks/check_yaml_definitions_authors.py` — Existing authors validator

  **WHY Each Reference Matters**:
  - Definition files are the source of truth for cross-references. If a skill ID in skills.yml is malformed, all activities referencing it would pass individual validation but fail at runtime.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All definition files validated
    Tool: Read / Bash
    Preconditions: Definition files exist
    Steps:
      1. Read each definition file
      2. Check YAML syntax validity
      3. Check license header present
      4. Check no duplicate IDs within each file
      5. Validate field completeness per definition type
    Expected Result: Report section "Definitions: 6 files scanned, N issues found"
    Evidence: .sisyphus/evidence/task-7-definitions.md

  Scenario: Author cross-reference check
    Tool: Bash (grep)
    Preconditions: authors.yml exists and content files reference authors
    Steps:
      1. Extract all unique author values from authors.yml
      2. Extract all author references from all *.new_activity.yml files
      3. Find any referenced author not in authors.yml
    Expected Result: List of any orphaned author references
    Evidence: .sisyphus/evidence/task-7-author-crossref.md
  ```

  **Commit**: NO (report only)

- [ ] 8. Text Quality Review — Curriculums Batch A (alphabetical 1-26) + Their Activities

  **What to do**:
  - Review text content in the FIRST 26 curriculum directories (alphabetical order) AND all their v2 activities in `new_activities/`
  - For EACH file, review ALL l10n text fields in BOTH `fr_FR` and `en_US`:
    - Top-level: `title`, `subtitle`, `short_description`, `description`, `instructions`
    - Exercise-level: `instructions[].value`
    - Action speech: `action.value.value[].utterance`
  - Flag ONLY these text issues (NOT pedagogical quality):
    - **Typos**: Obvious misspellings in either language
    - **Encoding errors**: Garbled characters, mojibake, broken Unicode
    - **Placeholder text**: `TODO`, `Lorem`, `XXX`, `FIXME`, `TBD`, or obviously incomplete text
    - **Empty/whitespace-only fields**: Fields that exist but contain only spaces or newlines
    - **Untranslated content**: French text appearing in `en_US` entries or English in `fr_FR`
    - **Truncated strings**: Text that appears cut off mid-sentence
    - **Broken formatting**: YAML multiline strings with incorrect indentation causing parse artifacts
  - Do NOT flag:
    - French disability-domain terminology (`personne accompagnée`, `aidant`, `pictogrammes`, etc.)
    - Style differences between curriculum authors
    - Pedagogical phrasing choices
  - Severity: **critical** (text is garbled/placeholder making content unusable), **warning** (typo or untranslated), **info** (minor formatting)
  - Write findings to structured section for `qa-reports/wave-2-text-quality.md`

  **Must NOT do**:
  - Do NOT fix any text
  - Do NOT suggest rewrites or improvements
  - Do NOT comment on educational content quality

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Must carefully read bilingual text in ~100+ files, catch subtle typos and encoding issues. Requires sustained attention to detail.
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 9, 10, 11, 12, 13)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Activity schema showing all text fields to check
  - First curriculum directory (alphabetical): inspect to understand typical text patterns

  **WHY Each Reference Matters**:
  - The schema documentation tells the agent exactly which nested paths contain text that needs review. Without this, agents miss exercise-level instructions and action speech utterances.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All text fields in batch A reviewed for quality
    Tool: Read
    Preconditions: Curriculum directories exist
    Steps:
      1. List first 26 curriculum directories (alphabetical)
      2. For each, read the .curriculum.yml and all .new_activity.yml files
      3. Check every l10n text field for the 7 issue types listed
      4. Record findings with file path, field path, locale, issue type
    Expected Result: Report section "Batch A: N curriculums + N activities scanned, N text issues found"
    Evidence: .sisyphus/evidence/task-8-text-batch-a.md

  Scenario: Untranslated content detection
    Tool: Read / Grep
    Preconditions: Files have both locales
    Steps:
      1. For each file, compare fr_FR and en_US title/description text
      2. Flag cases where en_US text contains French words or is identical to fr_FR
      3. Flag cases where fr_FR contains English text
    Expected Result: List of suspected untranslated entries
    Evidence: .sisyphus/evidence/task-8-untranslated.md
  ```

  **Commit**: NO (report only)

- [ ] 9. Text Quality Review — Curriculums Batch B (alphabetical 27-52) + Their Activities

  **What to do**:
  - Same exact process as Task 8, applied to curriculum directories 27-52 (alphabetical order) and their v2 activities
  - Same flag types, same severity grading, same exclusions
  - Write findings to structured section for `qa-reports/wave-2-text-quality.md`

  **Must NOT do**:
  - Same exclusions as Task 8

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Same as Task 8 — sustained attention to bilingual text quality
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 8, 10, 11, 12, 13)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:
  - Same as Task 8

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All text fields in batch B reviewed for quality
    Tool: Read
    Steps: Same as Task 8, applied to directories 27-52
    Expected Result: Report section "Batch B: N curriculums + N activities scanned, N text issues found"
    Evidence: .sisyphus/evidence/task-9-text-batch-b.md
  ```

  **Commit**: NO (report only)

- [ ] 10. Text Quality Review — Curriculums Batch C (alphabetical 53-78) + Their Activities

  **What to do**:
  - Same exact process as Task 8, applied to curriculum directories 53-78 (alphabetical order) and their v2 activities
  - Same flag types, same severity grading, same exclusions
  - Write findings to structured section for `qa-reports/wave-2-text-quality.md`

  **Must NOT do**:
  - Same exclusions as Task 8

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Same as Task 8
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 8, 9, 11, 12, 13)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:
  - Same as Task 8

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All text fields in batch C reviewed for quality
    Tool: Read
    Steps: Same as Task 8, applied to directories 53-78
    Expected Result: Report section "Batch C: N curriculums + N activities scanned, N text issues found"
    Evidence: .sisyphus/evidence/task-10-text-batch-c.md
  ```

  **Commit**: NO (report only)

- [ ] 11. Text Quality Review — Standalone Activities, Templates, and Gamepads

  **What to do**:
  - Review text content in all files under `newActivities/`:
    - `new_standalones/` — 11 standalone activities (dance_freeze, melody, super_simon variants, etc.)
    - `new_templates/` — 18 template activities
    - `new_gamepads/` — 4 gamepad activities
  - Total: 33 files
  - Same text quality checks as Task 8: typos, encoding errors, placeholders, empty fields, untranslated content, truncated strings
  - Note: Standalone/gamepad activities may have minimal text (specialized interfaces like `danceFreeze`, `melody` have less text than `touchToSelect`). Focus on whatever text fields exist.
  - Templates may have intentional placeholder-like text (they're templates) — flag but mark severity as `info` rather than `warning`
  - Write findings to structured section for `qa-reports/wave-2-text-quality.md`

  **Must NOT do**:
  - Same exclusions as Task 8
  - Do NOT flag template status itself as an issue

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: 33 files, smaller scope than curriculum batches but includes specialized activity types needing careful handling
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 8-10, 12, 13)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/newActivities/new_standalones/dance_freeze-6E2F7D56726C419EA534C614F777D934.new_activity.yml` — Example specialized activity with song payload
  - `Modules/ContentKit/Resources/Content/newActivities/new_templates/activity_template-0123456789ABCDEF0123456789ABCDEF.new_activity.yml` — Canonical template
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Schema for specialized interfaces

  **WHY Each Reference Matters**:
  - Specialized activities have different text fields than general activities (e.g., `danceFreeze` has song labels, not exercise instructions). The agent needs to understand each interface type to know where text lives.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All standalone/template/gamepad activities text-reviewed
    Tool: Read
    Steps:
      1. List all files in newActivities/ subdirectories
      2. Read each file, check all l10n text fields
      3. Apply same quality checks as Task 8
      4. Mark template placeholder text as info severity
    Expected Result: "Standalones: 11 scanned | Templates: 18 scanned | Gamepads: 4 scanned | Issues: N"
    Evidence: .sisyphus/evidence/task-11-text-standalones.md
  ```

  **Commit**: NO (report only)

- [ ] 12. Text Quality Review — Stories (All 6)

  **What to do**:
  - Review text content in all 6 story files (`*.story.yml`)
  - Stories have MORE text than activities — check:
    - Top-level l10n: `title`, `subtitle`, `short_description`, `description`, `instructions`
    - Per-page text items: `pages[].l10n[].items[].payload.text`
    - Button labels: `pages[].l10n[].items[].payload.text` (for `button_image` type)
    - Image alt text: `pages[].l10n[].items[].payload.text` (for `image` type)
  - Stories are narrative — check for story continuity (does text flow logically page-to-page?)
  - Flag only the same text issue types as Task 8 (typos, encoding, placeholders, untranslated)
  - Severity grading same as Task 8
  - Write findings to structured section for `qa-reports/wave-2-text-quality.md`

  **Must NOT do**:
  - Do NOT judge story quality or narrative choices
  - Do NOT suggest plot improvements
  - Same text exclusions as Task 8

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Only 6 files but stories are large with many pages of text content — moderate depth needed
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 8-11, 13)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/stories/hanna_meets_leka-FF7618528E194E8CB3A6950E08562D16.story.yml` — Example story with full page structure
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Story schema showing nested text locations

  **WHY Each Reference Matters**:
  - Story files have deeply nested text (page → l10n → items → payload → text) that's easy to miss. The schema documentation maps the full path.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All story text reviewed for quality
    Tool: Read
    Steps:
      1. Read each of 6 story files
      2. Check top-level l10n text fields
      3. Check every page's l10n items text fields
      4. Flag issues with file, page number, locale, field
    Expected Result: "Stories: 6 scanned, N pages total, N text issues found"
    Evidence: .sisyphus/evidence/task-12-text-stories.md
  ```

  **Commit**: NO (report only)

- [ ] 13. Text Quality Review — Curations + Definitions

  **What to do**:
  - Review text content in all 40 curation files (`*.curation.yml`)
  - Curations have: top-level l10n (`title`, `subtitle`, `description`) + per-content-section l10n (`title`, `subtitle`, `description`)
  - Also review text content in definition files that have l10n or text:
    - `definitions/authors.yml` — Author names, descriptions
    - `definitions/skills.yml` — Skill names (check for consistency)
    - `definitions/tags.yml` — Tag names
  - Same text quality checks as Task 8
  - Write findings to structured section for `qa-reports/wave-2-text-quality.md`

  **Must NOT do**:
  - Same exclusions as Task 8

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: 40 curations + 6 definition files — moderate scope with straightforward text fields
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 8-12)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curations/home-F4E2C104C09E436CB80A87749CE62DDF.curation.yml` — Example curation with section-level l10n
  - `Modules/ContentKit/Resources/Content/definitions/authors.yml` — Author definitions with text content
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Curation schema and definitions documentation

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All curation and definition text reviewed
    Tool: Read
    Steps:
      1. Read all 40 curation files, check top-level and section-level l10n text
      2. Read definition files, check text content
      3. Flag issues same as Task 8
    Expected Result: "Curations: 40 scanned, Definitions: 6 scanned, Issues: N"
    Evidence: .sisyphus/evidence/task-13-text-curations-defs.md
  ```

  **Commit**: NO (report only)

- [ ] 14. Curation → Content Reference Integrity

  **What to do**:
  - For EVERY curation file (40 files), extract ALL `items[].value` references
  - Each item has a `type` (curriculum | activity | curation) and a `value` (name-UUID)
  - Verify EVERY reference resolves to an existing content file:
    - `type: curriculum` → must match a `*.curriculum.yml` filename
    - `type: activity` → must match a `*.new_activity.yml` filename (v2 only)
    - `type: curation` → must match a `*.curation.yml` filename
  - Also check: subcurations referenced from parent curations exist
  - Also check: are there published content items (curriculums/activities) that appear in NO curation? (orphaned from navigation)
  - Severity: **critical** (reference points to non-existent content — broken UI), **warning** (content exists but in no curation — orphaned)
  - Write findings to `qa-reports/wave-3-integration.md`

  **Must NOT do**:
  - Do NOT check v1 activity references
  - Do NOT modify curations to fix broken references

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Complex cross-referencing between 40 curation files and 500+ content files, need to build and check a reference graph
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Tasks 15, 16)
  - **Blocks**: Task 17
  - **Blocked By**: Tasks 1, 4 (need curation structural validation first)

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curations/home-F4E2C104C09E436CB80A87749CE62DDF.curation.yml` — Top-level curation referencing subcurations and content
  - `Modules/ContentKit/Resources/Content/curations/subcurations/animals-0609CB09299847E581F6E191796499B4.curation.yml` — Subcuration referencing curriculums

  **API/Type References**:
  - `Modules/ContentKit/Resources/Content/AGENTS.md` — Reference chain documentation showing how curations link to content

  **WHY Each Reference Matters**:
  - The reference chain documentation shows the exact format of references (name-UUID) and valid types. Without this, the agent might miss the `type` field that determines what kind of content is expected.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All curation references resolve to existing content
    Tool: Bash / Read
    Steps:
      1. Extract all items[].value from all 40 curation files
      2. For each, determine type and look for matching file
      3. Flag any broken references
    Expected Result: "Total references: N, Resolved: N, Broken: N"
    Evidence: .sisyphus/evidence/task-14-curation-refs.md

  Scenario: Orphaned content detection (content in no curation)
    Tool: Bash
    Steps:
      1. Build list of all content IDs (activity + curriculum name-UUIDs)
      2. Build list of all IDs referenced in curations
      3. Find content IDs NOT in any curation
    Expected Result: List of published content not reachable via any curation
    Evidence: .sisyphus/evidence/task-14-orphaned-content.md
  ```

  **Commit**: NO (report only)

- [ ] 15. Curriculum → Activity Reference Integrity

  **What to do**:
  - For EVERY curriculum file (78 files), extract the `activities:` list (ordered list of activity name-UUIDs)
  - Verify EVERY referenced activity exists as a `*.new_activity.yml` file in the curriculum's `new_activities/` subdirectory
  - Check for: references to activities that DON'T exist, activities in `new_activities/` NOT referenced by the curriculum (orphaned within curriculum)
  - Also check: do any curriculums reference v1-only activities (activities in `activities/` but NOT in `new_activities/`)? This indicates incomplete v2 migration.
  - Severity: **critical** (referenced activity doesn't exist — broken curriculum), **warning** (orphaned activity in directory not referenced), **info** (v1-only reference detected)
  - Write findings to `qa-reports/wave-3-integration.md`

  **Must NOT do**:
  - Do NOT migrate v1 activities to v2
  - Do NOT modify curriculum activity lists
  - Do NOT add missing activity references

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: 78 curriculums each with activity lists to cross-reference against file system. Need to handle edge cases like the directory naming anomalies.
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Tasks 14, 16)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Modules/ContentKit/Resources/Content/curriculums/curriculum_recognition_body_parts-80761A1D62BF4C6980BF20E7D9BE52B8/curriculum_recognition_body_parts-80761A1D62BF4C6980BF20E7D9BE52B8.curriculum.yml` — Example curriculum with activities list
  - `Tools/Hooks/check_yaml_content_curriculums.py` — Existing validator that checks activity references — read to understand what it already covers

  **WHY Each Reference Matters**:
  - The existing curriculum validator may already check some references. Understanding its coverage prevents duplicate work. The directory naming anomalies (from Task 5) affect how activity files are located.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All curriculum activity references resolve
    Tool: Bash / Read
    Steps:
      1. For each curriculum, read activities list
      2. For each activity name-UUID, check if matching .new_activity.yml exists
      3. Flag missing activities
    Expected Result: "Curriculums: 78, Total refs: N, Resolved: N, Broken: N"
    Evidence: .sisyphus/evidence/task-15-curriculum-refs.md

  Scenario: v1-only activity detection
    Tool: Bash
    Steps:
      1. For each curriculum with both activities/ and new_activities/ dirs
      2. List activities in activities/ not present in new_activities/
      3. Check if curriculum references these v1-only activities
    Expected Result: List of curriculums still depending on v1-only activities
    Evidence: .sisyphus/evidence/task-15-v1-only-refs.md
  ```

  **Commit**: NO (report only)

- [ ] 16. Asset Reference & Orphaned Content Audit

  **What to do**:
  - Verify asset references in content files point to existing files:
    - Activity icons: `l10n[].details.icon` → check PNG exists in curriculum's `icons/` directory
    - Activity images: `payload.choices[].value` where `type: image` → check PNG exists in curriculum's `assets/` directory
    - Story backgrounds: `pages[].background` → check image exists
    - Story button images: `pages[].l10n[].items[].payload.idle` and `.pressed` → check images exist
    - Curation icons: `icon` field (SF Symbol names — can't verify existence but can check format)
  - Also check for orphaned assets: image files in `icons/` or `assets/` directories not referenced by any activity
  - Note: existing `check_yaml_content_activities_assets.py` likely covers some of this — check its output from Task 1 first
  - Severity: **critical** (referenced asset doesn't exist — broken display), **warning** (orphaned asset — wasted space), **info** (potential format issue)
  - Write findings to `qa-reports/wave-3-integration.md`

  **Must NOT do**:
  - Do NOT delete orphaned assets
  - Do NOT create missing assets
  - Do NOT open/validate image file contents (just check existence)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: File existence checks across many directories — moderate complexity, mostly filesystem operations
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Tasks 14, 15)
  - **Blocks**: Task 17
  - **Blocked By**: Task 1

  **References**:

  **Pattern References**:
  - `Tools/Hooks/check_yaml_content_activities_assets.py` — Existing asset validator. Read to understand what it covers.
  - Example curriculum with assets: browse any curriculum's `new_activities/icons/` and `new_activities/assets/` directories

  **WHY Each Reference Matters**:
  - The existing asset validator output (from Task 1) establishes what's already checked. This task fills gaps (story assets, orphaned files).

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All asset references resolve to existing files
    Tool: Bash
    Steps:
      1. Extract icon references from all activities and check file existence
      2. Extract image choice references and check file existence
      3. Extract story background/button image references and check existence
      4. Flag any broken references
    Expected Result: "Asset refs: N total, N resolved, N broken"
    Evidence: .sisyphus/evidence/task-16-asset-refs.md

  Scenario: Orphaned assets detection
    Tool: Bash
    Steps:
      1. List all PNG files in icons/ and assets/ directories
      2. Check each against references in activity files
      3. Flag unreferenced files
    Expected Result: List of orphaned asset files with sizes
    Evidence: .sisyphus/evidence/task-16-orphaned-assets.md
  ```

  **Commit**: NO (report only)

- [ ] 17. Compile Master Summary Report

  **What to do**:
  - Read ALL individual task evidence files from `.sisyphus/evidence/`
  - Read the existing validator output from Task 1
  - Compile a single master report at `qa-reports/master-summary.md` containing:
    - **Executive summary**: Total files scanned, total issues found per severity
    - **Per-content-type breakdown**: Activities, Curriculums, Stories, Curations, Definitions — each with issue counts by severity
    - **Top findings**: The most impactful issues (crash risks, broken references, silent failures)
    - **Known anomalies**: Pre-existing structural issues documented but not blocking
    - **Recommendations**: Prioritized list of fixes (critical first, then warnings, then info)
    - **Statistics table**: Content inventory with pass/fail per check type
  - Also compile the individual wave reports:
    - `qa-reports/wave-1-structural.md` — Aggregate all Wave 1 task findings
    - `qa-reports/wave-2-text-quality.md` — Aggregate all Wave 2 task findings
    - `qa-reports/wave-3-integration.md` — Aggregate all Wave 3 task findings
  - Ensure consistent table formatting across all reports
  - Verify totals add up (master summary totals = sum of wave report totals)

  **Must NOT do**:
  - Do NOT fix any issues mentioned in the reports
  - Do NOT modify content files
  - Do NOT include recommendations to change Swift code or Python scripts in the report

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Report compilation and aggregation — reads many evidence files, produces structured output. Needs attention to numerical accuracy.
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 4 (sequential after all other tasks)
  - **Blocks**: F1-F4
  - **Blocked By**: Tasks 2-16 (all must complete)

  **References**:

  **Pattern References**:
  - `.sisyphus/evidence/task-*` — All evidence files from Tasks 1-16

  **WHY Each Reference Matters**:
  - These ARE the inputs for this task. Every evidence file must be read and synthesized.

  **Acceptance Criteria**:

  **QA Scenarios (MANDATORY):**

  ```
  Scenario: All 4 report files created with correct structure
    Tool: Bash
    Steps:
      1. Verify: ls qa-reports/wave-1-structural.md qa-reports/wave-2-text-quality.md qa-reports/wave-3-integration.md qa-reports/master-summary.md
      2. Check each file is non-empty: wc -l qa-reports/*.md
      3. Check master summary has all expected sections: grep "Executive Summary\|Per-Content-Type\|Top Findings\|Recommendations" qa-reports/master-summary.md
    Expected Result: All 4 files exist, non-empty, with expected sections
    Evidence: .sisyphus/evidence/task-17-report-verification.md

  Scenario: Report totals are consistent
    Tool: Read
    Steps:
      1. Read master summary totals
      2. Read each wave report totals
      3. Verify master = wave-1 + wave-2 + wave-3
    Expected Result: No discrepancies in total counts
    Evidence: .sisyphus/evidence/task-17-totals-check.md
  ```

  **Commit**: YES
  - Message: `📝 (content): Add comprehensive QA audit reports for all v2 content`
  - Files: `qa-reports/wave-1-structural.md`, `qa-reports/wave-2-text-quality.md`, `qa-reports/wave-3-integration.md`, `qa-reports/master-summary.md`
  - Pre-commit: `ls qa-reports/*.md | wc -l` → expect 4

---

## Final Verification Wave (MANDATORY — after ALL implementation tasks)

> 4 review agents run in PARALLEL. ALL must APPROVE. Rejection → fix → re-run.

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Read the plan end-to-end. For each "Must Have": verify the corresponding report section exists with findings. For each "Must NOT Have": verify no content files were modified (`git diff --name-only` shows no `.yml` changes). Check all 4 report files exist in `qa-reports/`. Compare deliverables against plan.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Report Completeness Review** — `unspecified-high`
  Open each report file. Verify: every content type is covered (activities, curriculums, stories, curations, definitions). Every finding has severity grade. Master summary totals match individual report totals. No placeholder text in reports. Table format is consistent.
  Output: `Reports [4/4] | Content Types [5/5 covered] | Severity Grading [PASS/FAIL] | VERDICT`

- [ ] F3. **Sample Spot-Check Verification** — `deep`
  Pick 5 random findings from each report (15 total). For each: open the referenced file, go to the referenced location, verify the issue actually exists. Flag any false positives. Pick 3 files that have NO findings — verify they are genuinely clean.
  Output: `Spot Checks [N/15 verified] | False Positives [N] | Clean File Checks [N/3] | VERDICT`

- [ ] F4. **Scope Fidelity Check** — `deep`
  Verify: no v1 `.activity.yml` files were audited (unless checking curriculum cross-references). No Swift/Python/JSON files were modified. No content files were modified. All findings are within scope (structural, text quality, or integration — not pedagogical). No report suggests code fixes (only content fixes).
  Output: `v1 Exclusion [PASS/FAIL] | No Code Changes [PASS/FAIL] | Scope Compliance [PASS/FAIL] | VERDICT`

---

## Commit Strategy

- **No commits during QA** — this is an audit-only pass
- **After all reports complete**: Single commit with all 4 report files
  - Message: `📝 (content): Add comprehensive QA audit reports for all v2 content`
  - Files: `qa-reports/wave-1-structural.md`, `qa-reports/wave-2-text-quality.md`, `qa-reports/wave-3-integration.md`, `qa-reports/master-summary.md`

---

## Success Criteria

### Verification Commands
```bash
# All 4 report files exist
ls qa-reports/wave-1-structural.md qa-reports/wave-2-text-quality.md qa-reports/wave-3-integration.md qa-reports/master-summary.md

# No content files were modified
git diff --name-only -- "Modules/ContentKit/Resources/Content/" | wc -l
# Expected: 0

# Reports contain findings with severity
grep -c "critical\|warning\|info" qa-reports/master-summary.md
# Expected: > 0

# Master summary has total counts
grep "Total" qa-reports/master-summary.md
```

### Final Checklist
- [ ] All "Must Have" present: locale check, existing validators run, text quality in both languages, curation validation, severity grading
- [ ] All "Must NOT Have" absent: no auto-fixes, no v1 validation, no pedagogical rewrites, no code changes
- [ ] All 4 report files produced with structured findings
- [ ] Master summary aggregates all findings with counts per severity per content type
