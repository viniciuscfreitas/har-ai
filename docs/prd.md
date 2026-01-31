# Product Requirements Document (PRD)

**Project Name:** HAR.ai - Intelligent Network Analyzer
**Version:** 1.0 (MVP)
**Owner:** Vinícius Freitas
**Status:** Approved

## 1. Executive Summary
HAR.ai is a desktop tool designed for developers to automate the tedious process of analyzing network logs. By parsing `.har` (HTTP Archive) files and leveraging Generative AI, the tool identifies performance bottlenecks, redundant API calls, and logic errors (N+1 queries) in seconds, transforming raw logs into actionable engineering insights.

## 2. Problem Statement
**The Pain Point:** Developers often spend hours manually inspecting the "Network" tab in DevTools to debug latency issues or failed transactions. HAR files are dense, noisy (cluttered with images/fonts), and difficult for humans to parse holistically.
**The Solution:** An AI-powered assistant that reads the network trace, filters out the noise, and highlights exactly where the engineering team should focus their optimization efforts.

## 3. User Persona
* **The Senior Engineer:** Needs to audit an app's performance before a release.
* **The Debugger:** Needs to understand why a specific flow is failing in production without manually reading 5,000 lines of JSON.

## 4. Functional Requirements

### 4.1. Input & Parsing
* **[FR-01] Drag & Drop Ingestion:** Users must be able to drag a `.har` file directly into the application window.
* **[FR-02] Large File Handling:** The system must handle HAR files up to 50MB by processing them efficiently on the client side before upload.

### 4.2. "The Grug" Pre-Processing (Client-Side)
* **[FR-03] Noise Reduction:** The application must strip out heavy response bodies (images, binary data, massive HTML/CSS) *before* sending data to the backend.
* **[FR-04] Privacy First:** No sensitive header data (like Authorization Bearer tokens) should be logged permanently, though they may be analyzed for format correctness.

### 4.3. AI Analysis
* **[FR-05] Contextual Analysis:** The AI must look for specific patterns:
    * Status Code anomalies (4xx/5xx).
    * High Latency requests (>1s).
    * Duplicate requests (potential N+1 problems).
* **[FR-06] Actionable Feedback:** The output must not be generic; it should reference specific endpoints found in the log.

### 4.4. User Interface
* **[FR-07] Dashboard Metrics:** Before the detailed text, display high-level KPIs:
    * 🔴 Critical Errors count.
    * 🟡 Average Latency.
    * 🟢 Total Request count.
* **[FR-08] Markdown Rendering:** The detailed AI report must be rendered with proper formatting (bolding, lists, code blocks).

## 5. Non-Functional Requirements
* **Platform:** macOS/Windows (Flutter Desktop) to ensure stability with large file I/O.
* **Performance:** UI must remain responsive during file parsing (use of Isolates).
* **Architecture:** Clear separation of concerns between Client (Flutter) and Server (Python).

---