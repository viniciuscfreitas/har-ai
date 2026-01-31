# Remove AI Code Slop

Apply the simplicity filter: remove AI-generated complexity that doesn't add value.

Check diff against main and remove:

- Extra comments humans wouldn't write
- Defensive checks abnormal for trusted codepaths
- Type casts (any) that avoid real fixes
- Inconsistent style with existing codebase

Keep only what reduces cognitive load by at least 50%. Report 1-3 sentence summary of changes.
