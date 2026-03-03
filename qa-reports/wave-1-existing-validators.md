# Wave 1 — Existing Validator Output

**Generated**: 2026-03-03T10:49:48Z
**Working Directory**: /Users/ladislas/dev/leka/ios-monorepo
**Content Directory**: Modules/ContentKit/Resources/Content/

---

## Validator Execution Summary

All 10 validators were executed against the full content directory. All validators **PASSED** with exit code 0.

---

## check_yaml_content_new_activities.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Validates v2 activity files (`.new_activity.yml`) for schema compliance and missing exercise assets.

**Output**:
```
Check new_activity.yml files.............................................Passed
```

**Details**:
- Files Checked: 386 `.new_activity.yml` files
- Schema Validation: All files comply with `Specs/jtd/new_activity.jtd.json`
- Asset Validation: All referenced exercise assets exist
- No missing assets detected

---

## check_yaml_content_curriculums.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Validates curriculum files (`.curriculum.yml`) for schema compliance and activity references.

**Output**:
```
Check curriculum.yml files...............................................Passed
```

**Details**:
- Schema Validation: All curriculum files comply with `Specs/jtd/curriculum.jtd.json`
- Activity References: All referenced activities exist
- No missing or unreferenced activities detected

---

## check_yaml_content_stories.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Validates story files (`.story.yml`) for schema compliance.

**Output**:
```
Check story.yml files....................................................Passed
```

**Details**:
- Schema Validation: All story files comply with `Specs/jtd/story.jtd.json`
- No structural issues detected

---

## check_yaml_content_activities_unique_uuid.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Checks for UUID uniqueness in activity files (v1 format, `.activity.yml`).

**Output**:
```
Scanning for duplicate UUIDs in: Modules/ContentKit/Resources/Content

Scanned 377 activity files with 377 unique UUIDs

✅ No duplicate UUIDs found!
```

**Details**:
- Files Scanned: 377 `.activity.yml` files (v1 format)
- Unique UUIDs: 377 (100% unique)
- No duplicate UUIDs detected

---

## check_yaml_content_curriculums_unique_uuid.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Checks for UUID uniqueness in curriculum files.

**Output**:
```
Check curriculum.yml files for unique uuid...............................Passed
```

**Details**:
- All curriculum UUIDs are unique
- No duplicates detected

---

## check_yaml_content_stories_unique_uuid.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Checks for UUID uniqueness in story files.

**Output**:
```
Check story.yml files for unique uuid....................................Passed
```

**Details**:
- All story UUIDs are unique
- No duplicates detected

---

## check_yaml_content_activities_assets.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Checks for duplicate asset files in the ContentKit module (prevents files with same base name but different extensions).

**Output**:
```
Check activity.asset.* files.............................................Passed
```

**Details**:
- Files Scanned: All image files in `Modules/ContentKit/` (png, jpg, jpeg, svg)
- Excluded Paths: `.xcassets`, `.imageset` directories
- Duplicates Found: 0
- No duplicate base names detected

---

## check_yaml_definitions_skills.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Validates skill definitions (`definitions/skills.yml`) for schema compliance, unique IDs, and proper sorting.

**Output**:
```
Check skills.yml.........................................................Passed
```

**Details**:
- Schema Validation: Complies with `Specs/jtd/skills.jtd.json`
- Unique IDs: All skill IDs (including subskills) are unique
- Sorting: Entries are properly sorted by ID
- No structural issues detected

---

## check_yaml_definitions_tags.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Validates tag definitions (`definitions/tags.yml`) for schema compliance, unique IDs, and proper sorting.

**Output**:
```
Check tags.yml...........................................................Passed
```

**Details**:
- Schema Validation: Complies with `Specs/jtd/tags.jtd.json`
- Unique IDs: All tag IDs (including subtags) are unique
- Sorting: Entries are properly sorted by ID
- No structural issues detected

---

## check_yaml_definitions_authors.py

**Exit Code**: 0
**Status**: ✅ PASSED
**Description**: Validates author definitions (`definitions/authors.yml`) for schema compliance and unique IDs.

**Output**:
```
Check authors.yml........................................................Passed
```

**Details**:
- Schema Validation: Complies with `Specs/jtd/authors.jtd.json`
- Unique IDs: All author IDs are unique
- Sorting: Entries are properly sorted by ID
- No structural issues detected

---

## Findings Summary

### Critical Issues
**Count**: 0
No critical issues detected. No content loss or app crash risks identified.

### Warnings
**Count**: 0
No structural inconsistencies or warnings detected.

### Info
**Count**: 0
No style or minor issues detected.

---

## Overall Assessment

✅ **ALL VALIDATORS PASSED**

The content system is in excellent health:
- **386 v2 activities** validated with full schema compliance
- **377 v1 activities** scanned for UUID uniqueness (all unique)
- **All curriculums** validated with activity references intact
- **All stories** validated with schema compliance
- **All definitions** (skills, tags, authors) validated with unique IDs and proper sorting
- **Zero duplicate assets** detected
- **Zero structural issues** detected

### Validator Coverage

| Validator | Type | Status | Files Checked |
|-----------|------|--------|----------------|
| check_yaml_content_new_activities.py | Content | ✅ PASSED | 386 |
| check_yaml_content_curriculums.py | Content | ✅ PASSED | All |
| check_yaml_content_stories.py | Content | ✅ PASSED | All |
| check_yaml_content_activities_unique_uuid.py | UUID | ✅ PASSED | 377 |
| check_yaml_content_curriculums_unique_uuid.py | UUID | ✅ PASSED | All |
| check_yaml_content_stories_unique_uuid.py | UUID | ✅ PASSED | All |
| check_yaml_content_activities_assets.py | Assets | ✅ PASSED | All |
| check_yaml_definitions_skills.py | Definitions | ✅ PASSED | 1 |
| check_yaml_definitions_tags.py | Definitions | ✅ PASSED | 1 |
| check_yaml_definitions_authors.py | Definitions | ✅ PASSED | 1 |

---

## Execution Method

All validators were executed via the pre-commit framework, which automatically handles Python dependency installation (ruamel.yaml) and provides consistent execution environment.

```bash
pre-commit run <hook-id> --all-files
```

This ensures validators run with all required dependencies and in the correct working directory context.
