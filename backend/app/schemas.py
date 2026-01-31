from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional

class Entry(BaseModel):
    method: str
    url: str
    status: int
    timing: float = Field(..., description="Wait time / TTFB in ms")
    total_time: float = Field(..., description="Total time in ms")
    req_headers_count: int
    res_body_size: int
    mime_type: str = "unknown"

class Meta(BaseModel):
    version: str
    creator: Dict[str, Any]

class SanitizedLog(BaseModel):
    meta: Meta
    entries: List[Entry]

class AnalysisSummary(BaseModel):
    total_requests: int
    avg_latency_ms: float
    critical_errors: int

class AnalysisReport(BaseModel):
    summary: AnalysisSummary
    markdown_report: str
