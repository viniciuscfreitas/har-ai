# Optimize Performance

## Overview

Don't optimize unless you must. Only fix performance issues that actually hurt users. Prioritize simplicity and maintainability over micro-optimizations.

## Steps

1. **Validate the Problem**
    - Measure actual performance with real user data
    - Is this really slow enough to matter? (MVP: can it wait?)
    - Profile before optimizing - guesswork is expensive

2. **Chesterton's Fence Check**
    - Why is this code slow? Understand the intent before changing
    - Could be a design constraint, not a bug

3. **Simple Fixes First**
    - Fix obvious inefficiencies (O(n²) loops, unnecessary allocations)
    - Add basic caching for repeated expensive operations
    - Stop when performance is "good enough" - don't over-engineer

4. **Complex Solutions Only If Needed**
    - Advanced optimizations only for proven bottlenecks
    - Always prefer readable code over clever micro-optimizations

## Optimization Checklist

### Is This Actually Needed?
- [ ] Measured real performance impact on users
- [ ] Confirmed it's worth the complexity trade-off
- [ ] Can't be solved by simpler architectural changes?

### Simple Solutions First
- [ ] Fixed obvious algorithmic inefficiencies (O(n²) → O(n))
- [ ] Eliminated unnecessary allocations and computations
- [ ] Added basic caching for expensive operations

### When Complexity is Justified
- [ ] Only introduced complex optimizations for proven bottlenecks
- [ ] Maintainability impact assessed (can junior dev understand this?)
- [ ] Performance gains measured and documented
