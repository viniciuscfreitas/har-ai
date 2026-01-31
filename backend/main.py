from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

# Load env before importing other modules that might use it
load_dotenv()

from .app.schemas import SanitizedLog, AnalysisReport
from .app.ai_service import ai_service

app = FastAPI(title="HAR.ai Backend", version="1.0.0")

# CORS is required for Flutter to access localhost
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # For dev, allow all
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def health_check():
    return {"status": "ok", "service": "HAR.ai Backend"}

@app.post("/analyze", response_model=AnalysisReport)
def analyze_har(log: SanitizedLog):
    try:
        if not os.getenv("GEMINI_API_KEY"):
            raise HTTPException(status_code=500, detail="GEMINI_API_KEY not configured on server")
        
        return ai_service.analyze_log(log)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    host = os.getenv("API_HOST", "0.0.0.0")
    port = int(os.getenv("API_PORT", "8000"))
    debug_mode = os.getenv("DEBUG_MODE", "False").lower() == "true"

    if debug_mode:
        uvicorn.run("backend.main:app", host=host, port=port, reload=True)
    else:
        uvicorn.run(app, host=host, port=port)
