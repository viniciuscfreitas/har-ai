import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/har_model.dart';
import 'exceptions.dart';

class IsolateManager {
  Future<SanitizedLog> sanitizeHar(String filePath) async {
    return await compute(_sanitizeHarIsolate, filePath);
  }

  static SanitizedLog _sanitizeHarIsolate(String filePath) {
    // 1. Read file in Isolate to avoid main thread jank
    String fileContent;
    try {
      fileContent = File(filePath).readAsStringSync();
    } on FileSystemException catch (e) {
      throw UserException("Cannot read file: ${e.message}");
    }
    
    // 2. Defensive Decoding
    final dynamic rawJson;
    try {
      rawJson = jsonDecode(fileContent);
    } on FormatException catch (_) {
      throw UserException("File is not a valid JSON");
    }

    if (rawJson is! Map<String, dynamic>) {
      throw UserException("Invalid HAR: Root must be a JSON object");
    }

    if (!rawJson.containsKey('log')) {
       throw UserException("Invalid HAR: Missing 'log' field");
    }

    final log = rawJson['log'];
    if (log is! Map<String, dynamic>) {
       throw UserException("Invalid HAR: 'log' field must be an object");
    }

    final entries = (log['entries'] as List?) ?? [];

    // 3. Robust Mapping
    final sanitizedEntries = entries.map<SanitizedEntry?>((entry) {
      if (entry is! Map<String, dynamic>) return null;

      final request = entry['request'];
      final response = entry['response'];
      
      // Skip incomplete entries
      if (request is! Map<String, dynamic> || response is! Map<String, dynamic>) {
        return null;
      }

      final timings = entry['timings'] as Map<String, dynamic>?;

      // Extract wait time safely
      final timing = (timings?['wait'] as num?)?.toDouble() ?? 0.0;
      final totalTime = (entry['time'] as num?)?.toDouble() ?? 0.0;
      
      final headers = (request['headers'] as List?) ?? [];
      
      final content = response['content'] as Map<String, dynamic>?;

      return SanitizedEntry(
        method: request['method'] as String? ?? 'UNKNOWN',
        url: request['url'] as String? ?? '',
        status: response['status'] as int? ?? 0,
        timing: timing,
        totalTime: totalTime,
        reqHeadersCount: headers.length,
        resBodySize: response['bodySize'] as int? ?? 0,
        mimeType: content?['mimeType'] as String? ?? 'unknown',
      );
    }).whereType<SanitizedEntry>().toList();

    return SanitizedLog(
      meta: {
        'version': log['version'] ?? 'unknown',
        'creator': log['creator'] ?? {},
      },
      entries: sanitizedEntries,
    );
  }
}
