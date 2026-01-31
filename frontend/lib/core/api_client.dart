import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/har_model.dart';
import 'exceptions.dart';

class ApiClient {
  static const String _baseUrl = 'http://127.0.0.1:8000';

  Future<AnalysisReport> analyzeLog(SanitizedLog log) async {
    final url = Uri.parse('$_baseUrl/analyze');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(log.toJson()),
      );

      if (response.statusCode == 200) {
        return AnalysisReport.fromJson(jsonDecode(response.body));
      } else {
        throw UserException('Analysis failed: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw UserException("Server unreachable. Is the backend running?");
    } on http.ClientException catch (e) {
      throw UserException("Network error: ${e.message}");
    } catch (e) {
      throw SystemException("Unexpected error during analysis", e);
    }
  }
}
