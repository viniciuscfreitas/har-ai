# Architecture Decision Record (ADR)

**Project:** HAR.ai
**Date:** [Current Date]
**Status:** Accepted

## 1. Context
We are tasked with building a full-stack application to analyze network logs using AI within a constrained timeframe (6-8 hours). The solution must demonstrate full-stack fundamentals, thoughtful product engineering, and effective use of LLMs.

## 2. Decisions

### ADR-001: Flutter Desktop as the Target Platform
* **Context:** Web applications often struggle with large file manipulation (CORS, memory limits, browser main-thread blocking) when handling 50MB+ log files.
* **Decision:** Build the frontend using **Flutter targeting Desktop (macOS/Windows)**.
* **Consequences:**
    * (+) **Performance:** Direct access to the file system allows reading large files without browser overhead.
    * (+) **Stability:** Eliminates CORS issues during the demo video recording.
    * (+) **Dev Experience:** Leveraging existing Flutter expertise for a polished UI.
    * (-) **Distribution:** Requires users to download an executable (acceptable for an internal DevTool).

### ADR-002: Client-Side "Grug" Sanitization
* **Context:** Uploading a raw 50MB HAR file to a backend for processing is slow, bandwidth-intensive, and wasteful, as 90% of the content (image bodies, JS bundles) is irrelevant for logical analysis.
* **Decision:** Implement aggressive **Client-Side Sanitization** using Flutter Isolates.
* **Strategy:**
    1.  Parse the JSON locally in Dart.
    2.  Iterate through entries.
    3.  **Delete** `response.content.text` (bodies) and `cookie` arrays.
    4.  Send only the lightweight "skeleton" (Headers, Method, URL, Status, Timing) to the Backend.
* **Consequences:**
    * (+) **Speed:** Upload size drops from ~50MB to ~500KB. Analysis becomes near-instant.
    * (+) **Cost:** Drastically reduces Token usage on the LLM side.
    * (+) **UX:** User sees immediate progress.

### ADR-003: Python FastAPI Backend Layer
* **Context:** The challenge requires a backend API layer for separation of concerns.
* **Decision:** Use **Python with FastAPI**.
* **Consequences:**
    * (+) **Separation:** Keeps API keys (Gemini) secure on the server, never exposing them to the client.
    * (+) **Type Safety:** Pydantic models ensure the sanitized JSON from Flutter matches the expected schema before hitting the AI.
    * (+) **Simplicity:** Minimal boilerplate compared to other frameworks.

### ADR-004: Google Gemini 2.0 Flash
* **Context:** Network logs, even sanitized, can be long (many tokens).
* **Decision:** Use **Gemini 2.0 Flash**.
* **Consequences:**
    * (+) **Context Window:** The 1M token window comfortably handles long user sessions without needing complex chunking strategies.
    * (+) **Latency:** Faster inference time fits the "interactive tool" use case better than larger models like GPT-4o.

## 3. High-Level Architecture

```mermaid
sequenceDiagram
    participant User
    participant Flutter (Client)
    participant Python (API)
    participant Gemini (LLM)

    User->>Flutter: Drops .HAR File (50MB)
    activate Flutter
    Flutter->>Flutter: Isolate: Parse & Strip Bodies
    Flutter->>Python: POST /analyze (Payload: 200KB)
    deactivate Flutter
    activate Python
    Python->>Gemini: Send JSON Skeleton + Prompt
    activate Gemini
    Gemini-->>Python: Returns Markdown Analysis
    deactivate Gemini
    Python-->>Flutter: Returns Report
    deactivate Python
    Flutter->>User: Renders Dashboard & Insights