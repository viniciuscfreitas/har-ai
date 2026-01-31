# Accessibility Audit

## Overview

Start with semantic HTML - it's free accessibility. Only add complexity (ARIA, etc.) when semantic solutions fail. Prioritize WCAG AA compliance over perfection.

## Steps

1. **Validate the Need**
    - Who are your users? Do they need advanced accessibility?
    - MVP check: semantic HTML + keyboard navigation covers 80% of cases
    - Only pursue full WCAG AA if legally/business required

2. **Semantic First**
    - Use proper HTML elements (<button>, <input>, <label>)
    - Logical heading hierarchy (h1→h2→h3)
    - Form labels and error messages with semantic markup
    - Skip ARIA unless semantic HTML fails

3. **Simple Accessibility**
    - Keyboard navigation works with Tab/Enter/Space
    - Color contrast meets WCAG AA (4.5:1 normal, 3:1 large)
    - Focus indicators visible
    - Alt text on images

4. **Complex Solutions Only When Needed**
    - ARIA roles/attributes only for custom components
    - Screen reader announcements for dynamic content
    - Skip WCAG AAA unless specifically required

## Accessibility Checklist

### Basic Requirements Met?
- [ ] Semantic HTML used (<button>, <input>, proper headings)
- [ ] Keyboard navigation works (Tab, Enter, Space, Escape)
- [ ] Color contrast meets WCAG AA standards
- [ ] Images have alt text

### Advanced Only If Needed
- [ ] ARIA used only where semantic HTML insufficient
- [ ] Screen readers tested with real assistive tech
- [ ] Full WCAG AA compliance verified (only if required)

### Trade-offs Considered
- [ ] Accessibility complexity justified by user needs
- [ ] Simple semantic solutions preferred over complex ARIA
- [ ] Performance impact of accessibility features assessed
