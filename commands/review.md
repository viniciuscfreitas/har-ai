# Code Review

## Overview

Block bad changes. Approve only code that works, is maintainable, and secure. Prioritize simplicity and debuggability over cleverness.

## Steps

1. **Understand the change**
    - Read the PR description and related issues for context
    - Identify the scope of files and features impacted
    - Note any assumptions or questions to clarify with the author
2. **Validate functionality**
    - Confirm the code delivers the intended behavior
    - Exercise edge cases or guard conditions mentally or by running locally
    - Check error handling paths and logging for clarity
3. **Assess quality**
    - Ensure functions are focused, names are descriptive, and code is readable
    - Watch for duplication, dead code, or missing tests
    - Verify documentation and comments reflect the latest changes
4. **Review security and risk**
    - Look for injection points, insecure defaults, or missing validation
    - Confirm secrets or credentials are not exposed
    - Evaluate performance or scalability impacts of the change

## Review Checklist

### Functionality

- [ ] Intended behavior works and matches requirements
- [ ] Edge cases handled gracefully
- [ ] Error handling is appropriate and informative

### Code Quality

- [ ] Logic is simple and readable (< 3 files to understand)
- [ ] No unnecessary complexity or abstraction
- [ ] Variables explain business intent, not just type

### Security & Safety

- [ ] No obvious security vulnerabilities introduced
- [ ] Inputs validated and outputs sanitized
- [ ] Sensitive data handled correctly

## Additional Review Notes

- Architecture decisions justified (Chesterton's Fence: understand why existing code exists)
- Performance impact assessed
- Coding standards followed
- Resource management and error handling reviewed
- Suggest simple alternatives when complexity exceeds value

Provide direct feedback with specific examples and actionable fixes.
