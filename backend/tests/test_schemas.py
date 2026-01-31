import pytest
from pydantic import ValidationError
from app.schemas import SanitizedLog

def test_sanitized_log_validation():
    # Scenario: Valid data
    valid_data = {
        "meta": {"version": "1.2", "creator": {"name": "test", "version": "1.0"}},
        "entries": [
            {
                "method": "GET",
                "url": "https://example.com",
                "status": 200,
                "timing": 150.5,
                "total_time": 200.0,
                "req_headers_count": 5,
                "res_body_size": 1024,
                "mime_type": "application/json"
            }
        ]
    }
    log = SanitizedLog(**valid_data)
    assert len(log.entries) == 1
    assert log.entries[0].url == "https://example.com"

def test_sanitized_log_rejects_missing_fields():
    # Scenario: Invalid data (missing 'url')
    invalid_data = {
        "meta": {"version": "1.2", "creator": {}},
        "entries": [
            {
                "method": "GET",
                # "url": MISSING
                "status": 200,
                "timing": 100
            }
        ]
    }
    # Here we prove that Pydantic protects the system
    with pytest.raises(ValidationError):
        SanitizedLog(**invalid_data)
