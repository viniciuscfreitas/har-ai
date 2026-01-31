import os
from google import genai
from .schemas import SanitizedLog, AnalysisReport, AnalysisSummary

class AIService:
    def __init__(self):
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            # Fallback or error - for now we just print warning, but in prod we should fail
            print("WARNING: GEMINI_API_KEY not set")
        
        self.client = genai.Client(api_key=api_key)

    def analyze_log(self, data: SanitizedLog) -> AnalysisReport:
        # 1. Calculate basic metrics locally
        total_requests = len(data.entries)
        if total_requests == 0:
            return AnalysisReport(
                summary=AnalysisSummary(total_requests=0, avg_latency_ms=0, critical_errors=0),
                markdown_report="## No requests found in the HAR file."
            )

        total_latency = sum(e.total_time for e in data.entries)
        avg_latency = total_latency / total_requests
        critical_errors = sum(1 for e in data.entries if e.status >= 500 or e.status == 0)

        # 2. Prepare Prompt for Gemini
        # We limit the number of entries if it's too massive, though 1.5 Flash has 1M window.
        # Serialization:
        log_snippet = data.model_dump_json()

        prompt = f"""
        You are a Senior Network Reliability Engineer. Analyze this sanitized HAR log (JSON).

        Context Metrics:
        - Total Requests: {total_requests}
        - Avg Latency: {avg_latency:.2f}ms
        - Critical Errors: {critical_errors}

        Log Data:
        {log_snippet}

        SYSTEM INSTRUCTION:
        - Return ONLY the raw Markdown report.
        - DO NOT wrap the output in ```markdown code blocks```.
        - DO NOT add conversational text like "Here is the report".
        - Start directly with "# Network Performance Report".

        STRICT Output Format:

        # Network Performance Report

        ## 📊 Executive Summary
        [Summary here]

        ## 🔴 Critical Issues (Blockers)
        * **[Issue Name]**: [Description]

        ## 🟡 Performance Bottlenecks
        * **[Issue Name]**: [Description]

        ## 🟢 Optimization Opportunities
        * **[Suggestion]**: [Advice]

        ## 🛠️ Engineering Recommendations
        1. [Step 1]
        2. [Step 2]
        """

        # 3. Call AI
        try:
            response = self.client.models.generate_content(
                model=os.getenv("GEMINI_MODEL", "gemini-2.0-flash"),
                contents=prompt
            )
            report_text = response.text
        except Exception as e:
            report_text = f"## Error generating AI report\n\n{str(e)}"

        return AnalysisReport(
            summary=AnalysisSummary(
                total_requests=total_requests,
                avg_latency_ms=round(avg_latency, 2),
                critical_errors=critical_errors
            ),
            markdown_report=report_text
        )

ai_service = AIService()
