/// URL and input validation utilities.
class Validators {
  /// Validate if a string is a valid URL format.
  static bool isValidUrl(String url) {
    if (url.trim().isEmpty) return false;

    // Add protocol if missing for validation
    String testUrl = url.trim();
    if (!testUrl.startsWith('http://') && !testUrl.startsWith('https://')) {
      testUrl = 'https://$testUrl';
    }

    // Basic URL regex pattern
    final urlPattern = RegExp(
      r'^https?://'
      r'(([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}|'
      r'(\d{1,3}\.){3}\d{1,3})'
      r'(:\d+)?'
      r'(/[^\s]*)?$',
      caseSensitive: false,
    );

    return urlPattern.hasMatch(testUrl);
  }

  /// Validate URL and return error message if invalid.
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a URL';
    }
    if (!isValidUrl(value)) {
      return 'Invalid URL format';
    }
    return null;
  }

  /// Check if a string looks like a URL (loose check for QR codes).
  static bool looksLikeUrl(String text) {
    final trimmed = text.trim().toLowerCase();
    return trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.contains('.') && !trimmed.contains(' ');
  }

  /// Sanitize a URL string (trim whitespace, remove dangerous chars).
  static String sanitizeUrl(String url) {
    return url.trim().replaceAll(RegExp(r'[\s\n\r\t]'), '');
  }
}
