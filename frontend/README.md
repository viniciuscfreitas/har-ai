# HAR.ai - Intelligent Network Analysis Tool 🚀

**Built for the Moonshot Partners AI Challenge.**

HAR.ai takes the chaos of network debugging—thousands of requests, waterfall charts, and massive JSON files—and turns it into actionable engineering insights using **Generative AI** (Gemini 2.0 Flash).

Instead of just building a wrapper around an API, this project demonstrates **how to engineer AI systems** that are secure, performant, and privacy-conscious.

---

## 🎥 As Seen in the Demo

- **Storytelling Loader:** A fluid UI that communicates exactly what is happening (Reading file -> Sanitizing PII -> Thinking).
- **Security First:** All sensitive data (Cookies, Headers, Response Bodies) is sanitized *locally* in a background Isolate before it ever leaves the browser.
- **Copy Sanitized JSON:** Export the clean data to use with your own local LLM workflows (Cursor, VS Code).


---

## 🏗 Architecture

### Clean Architecture & Separation of Concerns

1.  **Frontend (Flutter):**
    *   **Isolates:** Heavy JSON parsing and sanitization happen off the main thread to ensure 60fps UI performance.
    *   **Liquid Animations:** Custom UI components for a premium feel.
2.  **Backend (FastAPI + Docker):**
    *   Simple, stateless orchestration layer.
    *   Handles communication with Google Gemini.
3.  **AI Engine:**
    *   **Gemini 2.0 Flash:** Optimized for speed and large context windows (perfect for large HAR files).

---

## 🛠 Getting Started

1.  **Run the Backend:**
    ```bash
    cd ../backend
    docker-compose up --build
    ```

2.  **Run the Frontend:**
    ```bash
    flutter run
    ```

---

## 🚀 Roadmap & Future Improvements

I deliberately deferred 3 strategic features to prioritize a stable, high-performance MVP. Here is what is coming next and why:

### 1. 🛡️ Intelligent PII Masking (Data Scrubbing)
*   **Current State:** I strip request bodies entirely to guarantee safety.
*   **The Improvement:** Integration with a library like **Microsoft Presidio** to detect CPF, Credit Cards, and Emails patterns and mask them (e.g., `***`), preserving the JSON structure.
*   **Why:** Resolves the "missing context" difficulty in debugging logical errors without compromising the specific security requirement of "zero data leaks".

### 2. ⚙️ In-App Configuration (Settings UI)
*   **Current State:** Configuration is managed via `.env` files.
*   **The Improvement:** A dedicated Settings screen in Flutter to allow users to swap API Keys, toggle between Gemini 1.5/2.0, or adjust sanitization strictness at runtime.
*   **Why:** Acknowledges that while hardcoding/env-vars are acceptable for a hackathon MVP, a production tool requires user-accessible configuration.

### 3. ☁️ Local LLM Support (Ollama)
*   **Current State:** Cloud-only (Google Gemini).
*   **The Improvement:** Native support for local inference connecting to a local Ollama instance (e.g., Llama 3) instead of Google Cloud.
*   **Why:** The ultimate enterprise privacy feature. Allows large corps to analyze sensitive network logs without any data ever leaving their internal network.
