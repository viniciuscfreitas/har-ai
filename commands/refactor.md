# Refactor Code

## Overview

Only refactor when complexity hurts understanding. Apply the 2x Value Rule: abstractions must reduce complexity by at least 50%. Don't "clean up" just for aesthetics.

## Steps

1. **Validate the Need**
    - Does this code hurt understanding? (>3 files to track logic?)
    - Can a junior dev understand this in 5 minutes?
    - MVP check: does this absolutely need to be refactored now?

2. **Chesterton's Fence Check**
    - Why is this code structured this way? Understand before changing
    - Preserve existing logic unless you understand the hidden constraints

3. **Apply Simplicity Filter**
    - Fix names that don't explain business intent
    - Reduce nesting and complex logic (locality of behavior)
    - Only extract functions if it reduces cognitive load by 50%

4. **Safety First**
    - Change behavior only if you understand why it exists
    - Test thoroughly - refactoring often introduces subtle bugs
    - Prefer small, safe changes over big rewrites

## Refactor Checklist

### Is This Actually Needed?
- [ ] Code is hard to understand (>3 files to track logic)
- [ ] Variables/functions don't explain business intent
- [ ] Logic is scattered (violates locality of behavior)

### Applied Simplicity Filter
- [ ] Fixed confusing names to explain business purpose
- [ ] Reduced nesting and improved locality of behavior
- [ ] Only extracted functions when reducing complexity by 50%

### Safety & Testing
- [ ] Understood why existing code was structured this way
- [ ] Preserved all existing behavior (Chesterton's Fence)
- [ ] Tested thoroughly - no subtle bugs introduced
