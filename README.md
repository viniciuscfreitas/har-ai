# HAR.ai - Network Analysis Tool

**Built for the Moonshot Partners AI Challenge.**

HAR.ai is a desktop application designed to automate the analysis of HTTP Archive (.har) logs. It parses large dataset files (50MB+) locally and uses Gemini 2.0 Flash to identify performance bottlenecks, N+1 queries, and critical errors.

This project was built to demonstrate full-stack engineering fundamentals, specifically focusing on handling heavy I/O operations without blocking the UI and ensuring data privacy before sending payloads to an LLM.

## Demo

[Watch the Demo Video (3 min)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)

## System Architecture

The application is structured to ensure stability and privacy when dealing with massive log files.

### 1. Frontend (Flutter Desktop)
We chose Flutter Desktop (macOS/Windows) over a Web App to bypass browser memory limits and thread-blocking issues common when parsing large JSON files.
* **Dart Isolates:** All file reading, JSON parsing, and sanitization occur on a background thread. This keeps the UI responsive (60fps) even when processing 50MB+ files.
* **Client-Side Sanitization:** Sensitive data (Cookies, Authorization headers, and Response Bodies) is stripped locally. The raw payload never leaves the user's machine; only metadata is sent to the backend.

### 2. Backend (FastAPI + Docker)
A lightweight Python service that acts as a secure gateway to the AI provider.
* **Pydantic Validation:** Enforces a strict schema for the sanitized logs. Invalid data is rejected before it costs tokens.
* **Security:** Manages Google Gemini API keys server-side, ensuring they are never exposed to the client application.

### 3. Intelligence (Gemini 2.0 Flash)
Selected for its large context window (1M+ tokens), allowing the analysis of extensive network sessions without complex chunking strategies.

## Setup & Installation

### Prerequisites
* Docker & Docker Compose
* Flutter SDK (3.x)
* A Google Gemini API Key

### 1. Backend Configuration
The backend requires an API Key to function.

1.  Navigate to the backend directory:
    ```bash
    cd backend
    ```
2.  Create a `.env` file:
    ```bash
    touch .env  # On Windows, create the file manually
    ```
3.  Add your API Key to the file:
    ```text
    GEMINI_API_KEY=your_actual_api_key_here
    GEMINI_MODEL=gemini-2.0-flash
    ```

### 2. Run the Backend
Start the service using Docker Compose. This ensures the environment matches exactly what was developed.

```bash
docker-compose up --build -d

```

*Verify that the container is running and healthy before proceeding.*

### 3. Run the Frontend

Open a new terminal in the project root.

```bash
cd frontend
flutter pub get
flutter run -d macos  # or windows

```

## Testing

The repository includes unit tests focusing on the most critical logic: schema validation and security sanitization.

```bash
# Backend Tests (Schema Validation)
cd backend
pytest

# Frontend Tests (Sanitization Logic)
cd frontend
flutter test

```

## Design Decisions & Trade-offs

Due to the time constraints of the challenge, I prioritized a stable MVP over feature completeness. Here are the trade-offs made and the roadmap for a production version:

**1. Data Sanitization vs. Debugging Context**

* *Current approach:* Request/Response bodies are stripped entirely to guarantee zero PII leakage.
* *Improvement:* Implement a PII Scrubber (using a library like Microsoft Presidio) to mask specific patterns (Credit Cards, Emails) while preserving the JSON structure. This would allow logical debugging without security risks.

**2. Configuration**

* *Current approach:* Configuration is handled via `.env` files.
* *Improvement:* Add a Settings UI in the Flutter app to allow users to input their own API Keys or toggle between different AI models at runtime.

**3. Local Inference**

* *Current approach:* Cloud-based inference (Google Gemini).
* *Improvement:* Add support for local LLMs via Ollama (Llama 3). This is a critical feature for enterprise environments where data cannot leave the internal network.

```