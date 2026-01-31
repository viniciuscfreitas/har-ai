# Generate Mermaid Diagram

## Overview

Only create diagrams when they simplify understanding. Bad diagrams add complexity - use only when they reduce cognitive load by at least 50%.

## Instructions

1. **Validate the Need**
    - Does this really need a diagram? Can text/code explain it simpler?
    - Will this diagram actually help understanding or just look pretty?

2. **Choose Simplest Type**
    - flowchart: basic flows
    - sequenceDiagram: interactions between components
    - classDiagram: only for complex inheritance
    - Use others only when these don't work

3. **Keep It Simple**
    - Max 10-12 nodes - split if more needed
    - Descriptive labels that explain business purpose
    - Only add labels to edges when they clarify (not just noise)

4. **Output**: Wrap in mermaid block, explain what it shows in 1-2 sentences.
