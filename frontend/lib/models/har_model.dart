class SanitizedEntry {
  final String method;
  final String url;
  final int status;
  final double timing;
  final double totalTime;
  final int reqHeadersCount;
  final int resBodySize;
  final String mimeType;

  SanitizedEntry({
    required this.method,
    required this.url,
    required this.status,
    required this.timing,
    required this.totalTime,
    required this.reqHeadersCount,
    required this.resBodySize,
    required this.mimeType,
  });

  Map<String, dynamic> toJson() => {
        'method': method,
        'url': url,
        'status': status,
        'timing': timing,
        'total_time': totalTime,
        'req_headers_count': reqHeadersCount,
        'res_body_size': resBodySize,
        'mime_type': mimeType,
      };
}

class SanitizedLog {
  final Map<String, dynamic> meta;
  final List<SanitizedEntry> entries;

  SanitizedLog({required this.meta, required this.entries});

  Map<String, dynamic> toJson() => {
        'meta': meta,
        'entries': entries.map((e) => e.toJson()).toList(),
      };
}

class AnalysisReport {
  final AnalysisSummary summary;
  final String markdownReport;

  AnalysisReport({required this.summary, required this.markdownReport});

  factory AnalysisReport.fromJson(Map<String, dynamic> json) {
    return AnalysisReport(
      summary: AnalysisSummary.fromJson(json['summary']),
      markdownReport: json['markdown_report'],
    );
  }
}

class AnalysisSummary {
  final int totalRequests;
  final double avgLatencyMs;
  final int criticalErrors;

  AnalysisSummary({
    required this.totalRequests,
    required this.avgLatencyMs,
    required this.criticalErrors,
  });

  factory AnalysisSummary.fromJson(Map<String, dynamic> json) {
    return AnalysisSummary(
      totalRequests: json['total_requests'],
      avgLatencyMs: (json['avg_latency_ms'] as num).toDouble(),
      criticalErrors: json['critical_errors'],
    );
  }
}
