# Run All Tests and Fix Failures

Run tests only when they add value. Bad tests are worse than no tests - they create false confidence and maintenance burden.

## Pragmatic Testing

- **Unit tests**: Test pure logic, not integration points
- **Integration tests**: Only for critical user flows
- **Skip flaky tests**: Better to delete than maintain unreliable tests

## Fix Approach

1. Run failing tests
2. Fix obvious bugs (not test issues)
3. Delete or skip broken tests that don't represent real user scenarios
4. Focus on tests that catch actual regressions

Report results in 1-2 sentences. If tests are mostly failing, codebase needs architectural fixes, not test fixes.
