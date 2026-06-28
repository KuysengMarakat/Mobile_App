import 'dart:convert';

/// Enumeration for scan result status.
enum ScanStatus { safe, warning, dangerous }

/// Model representing the result of a URL scan.
class ScanResultModel {
  final String url;
  final ScanStatus status;
  final int score; // 0-100, higher = more dangerous
  final List<String> reasons;
  final DateTime scannedAt;
  final String source; // 'local', 'api', 'heuristic'

  ScanResultModel({
    required this.url,
    required this.status,
    required this.score,
    required this.reasons,
    required this.scannedAt,
    required this.source,
  });

  /// Get the status as a display string.
  String get statusText {
    switch (status) {
      case ScanStatus.safe:
        return 'Safe';
      case ScanStatus.warning:
        return 'Warning';
      case ScanStatus.dangerous:
        return 'Dangerous';
    }
  }

  /// Get Khmer label for status.
  String get statusKhmer {
    switch (status) {
      case ScanStatus.safe:
        return 'សុវត្ថិភាព';
      case ScanStatus.warning:
        return 'ប្រយ័ត្ន';
      case ScanStatus.dangerous:
        return 'គ្រោះថ្នាក់';
    }
  }

  /// Get the primary reason or a default message.
  String get primaryReason {
    if (reasons.isEmpty) {
      switch (status) {
        case ScanStatus.safe:
          return 'No known threats detected.';
        case ScanStatus.warning:
          return 'Some suspicious patterns found.';
        case ScanStatus.dangerous:
          return 'This URL matches known dangerous patterns.';
      }
    }
    return reasons.first;
  }

  /// Convert reasons list to JSON string for database storage.
  String get reasonsJson => jsonEncode(reasons);

  /// Create from status string and reasons JSON.
  factory ScanResultModel.fromRecord({
    required String url,
    required String statusStr,
    required int score,
    required String reasonsJson,
    required String source,
    required String scannedAt,
  }) {
    ScanStatus status;
    switch (statusStr) {
      case 'safe':
        status = ScanStatus.safe;
        break;
      case 'warning':
        status = ScanStatus.warning;
        break;
      case 'dangerous':
        status = ScanStatus.dangerous;
        break;
      default:
        status = ScanStatus.warning;
    }

    List<String> reasons;
    try {
      reasons = List<String>.from(jsonDecode(reasonsJson));
    } catch (_) {
      reasons = [reasonsJson];
    }

    return ScanResultModel(
      url: url,
      status: status,
      score: score,
      reasons: reasons,
      scannedAt: DateTime.tryParse(scannedAt) ?? DateTime.now(),
      source: source,
    );
  }

  /// Convert status enum to string for storage.
  String get statusString {
    switch (status) {
      case ScanStatus.safe:
        return 'safe';
      case ScanStatus.warning:
        return 'warning';
      case ScanStatus.dangerous:
        return 'dangerous';
    }
  }

  @override
  String toString() =>
      'ScanResultModel(url: $url, status: $statusText, score: $score, source: $source)';
}
