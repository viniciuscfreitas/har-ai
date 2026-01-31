# Add Error Handling

## Overview

Handle obvious errors that actually occur. Don't build enterprise-grade error handling for simple scripts. Prioritize user-facing errors over internal logging.

## Steps

1. **Validate the Need**
    - What errors actually happen here? Check logs first
    - MVP check: does this code need complex error handling?
    - Focus on user-facing errors, not internal edge cases

2. **Simple Error Handling First**
    - Handle null/undefined inputs that cause crashes
    - Add try-catch for external calls (network, file I/O)
    - Provide clear error messages users can understand
    - Log errors for debugging, but don't over-engineer

3. **Complex Solutions Only When Proven**
    - Retry logic only for operations that actually fail transiently
    - Circuit breakers only for critical external dependencies
    - Graceful degradation for non-essential features

4. **Safety Check**
    - Don't hide errors that should crash the app
    - Test error paths - they often have bugs too
    - Prefer crashing fast over complex recovery

## Error Handling Checklist

### Basic Safety Met?
- [ ] Handles obvious crashes (null/undefined inputs)
- [ ] External calls wrapped in try-catch
- [ ] Clear error messages for users
- [ ] Errors logged for debugging

### Advanced Only If Needed
- [ ] Retry logic only where failures are actually transient
- [ ] Circuit breakers only for critical dependencies
- [ ] Graceful degradation for non-essential features

### Complexity Trade-off
- [ ] Error handling doesn't make code significantly more complex
- [ ] Tested error paths work correctly
- [ ] Prefer simple crashes over complex recovery when appropriate
