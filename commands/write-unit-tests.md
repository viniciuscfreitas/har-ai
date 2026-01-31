# Write Unit Tests

Write tests only for code that actually needs testing. Focus on pure logic functions - skip integration points and UI components.

## When to Write Tests

- **Pure functions**: Yes, test these thoroughly
- **API calls**: No, use integration tests instead
- **UI components**: No, too brittle and low value
- **Complex business logic**: Yes, but keep tests simple

## Keep It Simple

- Test the happy path + 1-2 important edge cases
- Use descriptive names that explain what breaks if test fails
- Skip mocks when possible - test real behavior
- Delete tests that become maintenance burden

Report what was tested in 1-2 sentences. If code is too complex to test simply, simplify the code first.
