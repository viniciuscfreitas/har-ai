# HAR.ai

HAR.ai is a tool for analyzing HAR (HTTP Archive) files using local AI processing (sanitization) and Gemini AI (analysis).

## 🚀 Getting Started

### Prerequisites

- [Docker](https://www.docker.com/) (for Backend)
- [Flutter SDK](https://flutter.dev/) (for Frontend)

### 1. Backend Setup

The backend handles the AI analysis and requires a valid Gemini API Key.

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create a `.env` file based on the example:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` and paste your Google Gemini API Key:
   ```env
   GEMINI_API_KEY=your_actual_api_key
   AI_MODEL=gemini-1.5-flash
   ```
4. Run with Docker Compose (from the root directory):
   ```bash
   cd ..
   docker compose up --build
   ```
   The backend will be available at `http://localhost:8000`.

### 2. Frontend Setup

The frontend is a Flutter desktop application (macOS/Windows).

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run -d macos
   # or
   flutter run -d windows
   ```

## 🛡️ Security Note

- The `.env` file containing your API key is ignored by git. **Do not commit it.**
- The frontend sanitizes HAR files locally before sending prompts to the backend.
