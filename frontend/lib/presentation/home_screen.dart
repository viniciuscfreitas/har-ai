import 'dart:io';
import 'dart:async'; // Added for typewriter timer
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';

import '../core/api_client.dart';
import '../core/isolate_manager.dart';
import '../models/har_model.dart';
import '../core/exceptions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDragging = false;
  bool _isProcessing = false;
  String? _statusMessage;
  AnalysisReport? _report;
  SanitizedLog? _sanitizedLog;
  
  // Typewriter effect state
  String _displayedReport = "";
  Timer? _typewriterTimer;

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _startTypewriter(String fullText) {
    _typewriterTimer?.cancel();
    _displayedReport = "";
    int currentIndex = 0;
    
    // Speed: 5 chars every 10ms = 500 chars/second (Fast but readable)
    const chunkSize = 5;
    
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (currentIndex < fullText.length) {
        setState(() {
          int nextIndex = currentIndex + chunkSize;
          if (nextIndex > fullText.length) nextIndex = fullText.length;
          
          _displayedReport += fullText.substring(currentIndex, nextIndex);
          currentIndex = nextIndex;
        });
      } else {
        timer.cancel();
      }
    });
  }

  final IsolateManager _isolateManager = IsolateManager();
  final ApiClient _apiClient = ApiClient();

  Future<void> _handleFile(File file) async {
    // 1. Reading File
    setState(() {
      _isProcessing = true;
      _statusMessage = "Reading file..."; // Step 1: Reading
      _report = null;
      _displayedReport = ""; // Reset typewriter
      _sanitizedLog = null;
    });

    try {
      // Visual validation: Ensure "Reading" is visible
      await Future.delayed(const Duration(milliseconds: 500));

      // 2. Sanitizing (Security Validation)
      setState(() {
        _statusMessage = "Sanitizing sensitive data...";
      });

      // Run sanitize in parallel with a minimum delay to ensure the message is read
      // This visualizes the "Isolate" architecture and security focus
      final results = await Future.wait([
        _isolateManager.sanitizeHar(file.path),
        Future.delayed(const Duration(milliseconds: 1500)) // 1.5s to really let it sink in
      ]);
      
      final sanitizedLog = results[0] as SanitizedLog;
      
      // 3. AI Analysis
      setState(() {
        _sanitizedLog = sanitizedLog;
        _statusMessage = "Thinking..."; // Step 3: API Call
      });

      final report = await _apiClient.analyzeLog(sanitizedLog);

      setState(() {
        _report = report;
        _isProcessing = false;
        _statusMessage = null;
      });
      
      // Start typewriter effect
      _startTypewriter(report.markdownReport);

    } on UserException catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = e.message;
      });
    } on SystemException catch (e) {
      // Log internal error here (e.originalError)
      print("System Error: $e"); 
      setState(() {
        _isProcessing = false;
        _statusMessage = "System Error: ${e.message}";
      });
    } catch (e) {
      print("Unexpected Error: $e");
      setState(() {
        _isProcessing = false;
        _statusMessage = "Unexpected Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_graph, color: Theme.of(context).colorScheme.primary),
            const Gap(12),
            const Text("HAR.ai", style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showGuide,
            tooltip: "Guide",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Panel: Drop Zone & Metrics
            SizedBox(
              width: 360, // Fixed width for stability
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDropZone(),
                  const Gap(24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: _report != null
                        ? _buildMetrics(_report!.summary)
                        : _buildFeatureHighlights(),
                  ),
                ],
              ),
            ),
            const Gap(24),
            // Right Panel: Markdown Report
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: _buildReportPanel(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropZone() {
    final colorScheme = Theme.of(context).colorScheme;
    final isHovering = _isDragging;

    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        if (details.files.isNotEmpty) {
          _handleFile(File(details.files.first.path));
        }
      },
      child: Semantics(
        label: "Upload HAR file area",
        button: true,
        child: InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowedExtensions: ['har', 'json', 'txt'],
              type: FileType.custom
            );
            if (result != null) {
              _handleFile(File(result.files.single.path!));
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              color: isHovering ? colorScheme.primary.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: isHovering ? colorScheme.primary : const Color(0xFFE2E8F0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isHovering ? colorScheme.primary.withOpacity(0.1) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32,
                      color: isHovering ? colorScheme.primary : const Color(0xFF64748B),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    "Drop HAR file here",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B), // Slate 800
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "or click to browse",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF64748B), // Slate 500
                    ),
                  ),
                  const Gap(16),
                  // Conversion Element: Value Prop
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Text(
                      "🚀 Get instant performance insights",
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(AnalysisSummary summary) {
    return Column(
      children: [
        _buildMetricCard(
          label: "Total Requests", 
          value: "${summary.totalRequests}", 
          color: const Color(0xFF4F46E5), // Indigo
          icon: Icons.data_usage
        ),
        const Gap(12),
        _buildMetricCard(
          label: "Avg. Latency", 
          value: "${summary.avgLatencyMs}ms", 
          color: const Color(0xFFF59E0B), // Amber
          icon: Icons.timer_outlined
        ),
        const Gap(12),
        _buildMetricCard(
          label: "Critical Errors", 
          value: "${summary.criticalErrors}", 
          color: summary.criticalErrors > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981), // Red / Emerald
          icon: summary.criticalErrors > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline
        ),
      ],
    );
  }

  Widget _buildFeatureHighlights() {
    return Column(
      children: [
        _buildHighlightRow(Icons.bolt, "Instant Performance Analysis"),
        const Gap(16),
        _buildHighlightRow(Icons.security, "Security Vulnerability Scan"),
        const Gap(16),
        _buildHighlightRow(Icons.insights, "AI-Driven Optimization Tips"),
      ],
    );
  }

  Widget _buildHighlightRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
        const Gap(12),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String label, required String value, required Color color, required IconData icon}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B), // Slate 500
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B), // Slate 800
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportPanel() {
    // 1. Loading State (Process Disclosure)
    if (_isProcessing) {
      return Center(
        key: const ValueKey("loading"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ),
            const Gap(32),
            Text(
              _statusMessage ?? "Analyzing network patterns...",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const Gap(8),
            const Text(
              "This may take a few seconds",
              style: TextStyle(color: Color(0xFF94A3B8)),
            )
          ],
        ),
      );
    }

    // 2. Empty State (Visual Proof / Encouragement)
    if (_report == null) {
      if (_statusMessage != null) {
          return Center(
            key: const ValueKey("error"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const Gap(16),
                Text(_statusMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
              ],
            ),
          );
      }
      return Center(
        key: const ValueKey("empty"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.analytics_outlined, size: 64, color: const Color(0xFFCBD5E1)),
            ),
            const Gap(24),
            const Text(
              "Ready to Analyze",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFCBD5E1),
              ),
            ),
            const Gap(8),
            const Text(
              "Upload a HAR file to see the magic happen",
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    // 3. Report Content
    return Column(
      key: const ValueKey("report"),
      children: [
        // Report Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5), // Green/Mint
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
              ),
              const Gap(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Analysis Complete",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    "Generated at ${DateTime.now().hour}:${DateTime.now().minute}",
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () async {
                  if (_sanitizedLog != null) {
                    final jsonStr = const JsonEncoder.withIndent('  ').convert(_sanitizedLog!.toJson());
                    await Clipboard.setData(ClipboardData(text: jsonStr));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sanitized JSON copied! Ready for Cursor.")),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.code, size: 18),
                label: const Text("Copy JSON"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              const Gap(12),
              ElevatedButton.icon(
                onPressed: _copyReport,
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text("Copy Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  foregroundColor: const Color(0xFF475569),
                  elevation: 0,
                ),
              )
            ],
          ),
        ),
        // Markdown Content
        Expanded(
          child: Markdown(
            data: _displayedReport, // Use the streaming text
            selectable: true,
            padding: const EdgeInsets.all(32),
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -1),
              h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
              h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              p: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF475569)),
              code: const TextStyle(backgroundColor: Color(0xFFF1F5F9), fontFamily: 'Courier', fontSize: 14),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              blockquote: const TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic),
              blockquoteDecoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFCBD5E1), width: 4)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF4F46E5)),
            Gap(10),
            Text("How to use HAR.ai"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideStep(1, "Export a HAR file from your browser's Network tab."),
            const Gap(12),
            _buildGuideStep(2, "Drag & drop the file into the upload area."),
            const Gap(12),
            _buildGuideStep(3, "Wait for the AI to analyze performance & security."),
            const Gap(12),
            _buildGuideStep(4, "Review reliability scores and optimization tips."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            shape: BoxShape.circle,
          ),
          child: Text(
            "$number",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4F46E5),
              fontSize: 12,
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF334155), height: 1.4),
          ),
        ),
      ],
    );
  }

  Future<void> _copyReport() async {
    if (_report == null) return;

    await Clipboard.setData(ClipboardData(text: _report!.markdownReport));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Report copied to clipboard! Ready to paste into LLM."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
