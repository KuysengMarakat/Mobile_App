import 'dart:convert';
import 'package:flutter/services.dart';

/// Loads and manages the local list of known dangerous URLs/domains.
class BadUrlLoader {
  static final BadUrlLoader _instance = BadUrlLoader._internal();
  List<String> _badUrls = [];
  bool _isLoaded = false;

  factory BadUrlLoader() => _instance;

  BadUrlLoader._internal();

  /// Load the bad URLs from the local JSON asset file.
  Future<void> loadBadUrls() async {
    if (_isLoaded) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/bad_urls.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _badUrls = jsonList.cast<String>().map((url) => url.toLowerCase()).toList();
      _isLoaded = true;
    } catch (e) {
      // If loading fails, initialize with empty list
      _badUrls = [];
      _isLoaded = true;
    }
  }

  /// Check if a URL or domain exists in the local bad URL list.
  bool isUrlDangerous(String url) {
    final normalizedUrl = url.toLowerCase().trim();

    // Extract domain from the URL
    String domain = _extractDomain(normalizedUrl);

    // Check if the domain or full URL matches any entry in the bad list
    for (final badUrl in _badUrls) {
      if (domain.contains(badUrl) || normalizedUrl.contains(badUrl)) {
        return true;
      }
    }
    return false;
  }

  /// Get the matched bad URL entry if found.
  String? getMatchedBadUrl(String url) {
    final normalizedUrl = url.toLowerCase().trim();
    String domain = _extractDomain(normalizedUrl);

    for (final badUrl in _badUrls) {
      if (domain.contains(badUrl) || normalizedUrl.contains(badUrl)) {
        return badUrl;
      }
    }
    return null;
  }

  /// Extract domain from a URL string.
  String _extractDomain(String url) {
    String domain = url;

    // Remove protocol
    if (domain.startsWith('http://')) {
      domain = domain.substring(7);
    } else if (domain.startsWith('https://')) {
      domain = domain.substring(8);
    }

    // Remove path
    final pathIndex = domain.indexOf('/');
    if (pathIndex != -1) {
      domain = domain.substring(0, pathIndex);
    }

    // Remove port
    final portIndex = domain.indexOf(':');
    if (portIndex != -1) {
      domain = domain.substring(0, portIndex);
    }

    return domain;
  }

  /// Get the total number of loaded bad URLs.
  int get badUrlCount => _badUrls.length;

  /// Whether the bad URL list has been loaded.
  bool get isLoaded => _isLoaded;
}
