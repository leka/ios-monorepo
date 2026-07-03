# Old activity resource audit

Generated after deleting the deprecated `.activity.yml` catalog and old activity source trees.

## Summary

- Deprecated `.activity.yml` files: removed.
- Old source trees: removed.
- Legacy `Resources/Content/activities` folders: removed.
- Remaining activity media, icons, and audio assets: moved into new activity resource folders.

## Current resource layout

- Shared/new standalone activity assets now live under `Modules/ContentKit/Resources/Content/newActivities/`.
- Curriculum-scoped activity assets now live under each curriculum's `new_activities/` folder, preserving their `assets/`, `icons/`, and audio subfolders.

## Verification

- `find Modules/ContentKit/Resources/Content -path '*/activities/*' -type f` returns no files.
- Runtime references continue to use asset basenames, so moving files between resource folders does not require YAML payload changes.
