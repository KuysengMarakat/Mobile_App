import '../models/scan_result_model.dart';
import '../data/local/bad_url_loader.dart';
import 'virus_total_service.dart';

/// Service that orchestrates URL scanning using multiple detection methods:
/// local bad URL list, heuristic analysis, and VirusTotal API.
class UrlScannerService {
  final BadUrlLoader _badUrlLoader;
  final VirusTotalService _virusTotalService;

  UrlScannerService({
    BadUrlLoader? badUrlLoader,
    VirusTotalService? virusTotalService,
  })  : _badUrlLoader = badUrlLoader ?? BadUrlLoader(),
        _virusTotalService = virusTotalService ?? VirusTotalService();

  /// Main scan method — scans a URL through all detection layers.
  Future<ScanResultModel> scanUrl(String url) async {
    final normalizedUrl = _normalizeUrl(url);

    // Ensure bad URL list is loaded
    await _badUrlLoader.loadBadUrls();

    // Step 1: Check local bad URL list
    if (_badUrlLoader.isUrlDangerous(normalizedUrl)) {
      final matchedUrl = _badUrlLoader.getMatchedBadUrl(normalizedUrl);
      return ScanResultModel(
        url: normalizedUrl,
        status: ScanStatus.dangerous,
        score: 95,
        reasons: [
          'URL matches known dangerous domain: ${matchedUrl ?? "unknown"}',
          'This domain is in our local threat database.',
          'Do not enter any personal information on this site.',
        ],
        scannedAt: DateTime.now(),
        source: 'local',
      );
    }

    // Step 2: Heuristic analysis
    final heuristicResult = _performHeuristicAnalysis(normalizedUrl);
    if (heuristicResult.status == ScanStatus.dangerous) {
      return heuristicResult;
    }

    // Step 3: VirusTotal API scan
    final apiResult = await _virusTotalService.scanUrl(normalizedUrl);

    // Combine results — take the worst result
    if (apiResult != null &&
        apiResult.score > heuristicResult.score) {
      return apiResult;
    }

    // If heuristic found something suspicious, return that
    if (heuristicResult.status != ScanStatus.safe) {
      return heuristicResult;
    }

    // If API result exists, return it
    if (apiResult != null) {
      return apiResult;
    }

    // Default: safe
    return ScanResultModel(
      url: normalizedUrl,
      status: ScanStatus.safe,
      score: 5,
      reasons: [
        'No threats detected in local database.',
        'Heuristic analysis found no suspicious patterns.',
        'URL appears to be safe.',
      ],
      scannedAt: DateTime.now(),
      source: 'heuristic',
    );
  }

  /// Perform heuristic analysis on the URL looking for suspicious patterns.
  ScanResultModel _performHeuristicAnalysis(String url) {
    final List<String> suspiciousReasons = [];
    int score = 0;

    // Check for IP address instead of domain
    final ipPattern = RegExp(r'https?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}');
    if (ipPattern.hasMatch(url)) {
      suspiciousReasons.add('URL uses an IP address instead of a domain name.');
      score += 30;
    }

    // Check for too many subdomains (more than 3 dots in domain)
    final domain = _extractDomain(url);
    final dotCount = domain.split('.').length - 1;
    if (dotCount > 3) {
      suspiciousReasons.add('URL contains too many subdomains ($dotCount levels).');
      score += 20;
    }

    // Check for suspicious keywords
    final suspiciousKeywords = [
      'login', 'verify', 'secure', 'update', 'free', 'gift',
      'account', 'confirm', 'urgent', 'suspended', 'winner',
      'prize', 'claim', 'reward', 'reset-password', 'signin',
      'banking', 'paypal', 'netflix', 'apple-id',
    ];
    final lowerUrl = url.toLowerCase();
    final foundKeywords = <String>[];
    for (final keyword in suspiciousKeywords) {
      if (lowerUrl.contains(keyword)) {
        foundKeywords.add(keyword);
      }
    }
    if (foundKeywords.length >= 2) {
      suspiciousReasons.add(
          'URL contains multiple suspicious keywords: ${foundKeywords.join(", ")}.');
      score += 25;
    } else if (foundKeywords.length == 1) {
      suspiciousReasons.add(
          'URL contains a suspicious keyword: "${foundKeywords.first}".');
      score += 10;
    }

    // Check for unusually long URL (more than 100 characters)
    if (url.length > 100) {
      suspiciousReasons.add(
          'URL is unusually long (${url.length} characters). Phishing URLs often hide data in long strings.');
      score += 15;
    }

    // Check for HTTP instead of HTTPS
    if (url.startsWith('http://') && !url.startsWith('https://')) {
      suspiciousReasons.add(
          'URL uses HTTP instead of HTTPS. The connection is not encrypted.');
      score += 20;
    }

    // Check for strange characters (encoded characters, @, etc.)
    if (url.contains('@') || url.contains('%40')) {
      suspiciousReasons.add(
          'URL contains @ symbol which can be used to hide the real destination.');
      score += 25;
    }

    // Check for excessive hyphens in domain
    if (domain.contains('--') || domain.split('-').length > 4) {
      suspiciousReasons.add(
          'Domain contains excessive hyphens, common in phishing URLs.');
      score += 15;
    }

    // Check for number-letter mixing in domain
    final domainParts = domain.split('.');
    for (final part in domainParts) {
      if (part.length > 5 &&
          RegExp(r'\d').hasMatch(part) &&
          RegExp(r'[a-z]').hasMatch(part.toLowerCase())) {
        final digitRatio = part.replaceAll(RegExp(r'[^\d]'), '').length / part.length;
        if (digitRatio > 0.3 && digitRatio < 0.7) {
          suspiciousReasons.add(
              'Domain contains suspicious mix of letters and numbers.');
          score += 10;
          break;
        }
      }
    }

    // Determine status based on score
    ScanStatus status;
    if (score >= 60) {
      status = ScanStatus.dangerous;
    } else if (score >= 25) {
      status = ScanStatus.warning;
    } else {
      status = ScanStatus.safe;
      if (suspiciousReasons.isEmpty) {
        suspiciousReasons.add('No suspicious patterns detected.');
      }
    }

    return ScanResultModel(
      url: url,
      status: status,
      score: score.clamp(0, 100),
      reasons: suspiciousReasons,
      scannedAt: DateTime.now(),
      source: 'heuristic',
    );
  }

  /// Normalize a URL for consistent scanning.
  String _normalizeUrl(String url) {
    String normalized = url.trim();

    // Add protocol if missing
    if (!normalized.startsWith('http://') &&
        !normalized.startsWith('https://')) {
      normalized = 'https://$normalized';
    }

    // Remove trailing slash
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }

  /// Extract domain from URL.
  String _extractDomain(String url) {
    String domain = url;
    if (domain.startsWith('http://')) {
      domain = domain.substring(7);
    } else if (domain.startsWith('https://')) {
      domain = domain.substring(8);
    }
    final pathIndex = domain.indexOf('/');
    if (pathIndex != -1) {
      domain = domain.substring(0, pathIndex);
    }
    final portIndex = domain.indexOf(':');
    if (portIndex != -1) {
      domain = domain.substring(0, portIndex);
    }
    return domain;
  }
}
