# Debug Issue

## Overview

Fix bugs efficiently. Start with simplest explanations first. Don't over-debug - some bugs can be worked around cheaper than fixed.

## Steps

1. **Validate the Problem**
    - Is this bug worth fixing? Cost vs impact?
    - Can it be worked around cheaper than debugged?
    - MVP check: does this block users or just annoy devs?

2. **Simple Hypotheses First**
    - Check obvious causes: null checks, typos, wrong variable names
    - Add console.log for key variables - don't over-engineer
    - Test assumptions one by one, simplest first

3. **Systematic Only When Needed**
    - Use debugger only for complex logic (>3 files involved)
    - Focus on root cause, not symptoms
    - Stop when you find the fix - don't explore every edge case

4. **Fix & Verify**
    - Apply minimal fix that works
    - Test the fix thoroughly
    - Add regression test if it's a real bug

## Debug Checklist

### Is This Worth Fixing?
- [ ] Bug actually impacts users (not just dev annoyance)
- [ ] Cost of debugging < cost of workaround
- [ ] Not a "won't fix" scenario

### Simple Fixes Tried?
- [ ] Checked obvious causes (null, typos, variable names)
- [ ] Added basic logging to isolate issue
- [ ] Tested simple hypotheses first

### Root Cause Found?
- [ ] Found actual cause, not just symptoms
- [ ] Applied minimal fix that works
- [ ] Tested fix doesn't break other things
