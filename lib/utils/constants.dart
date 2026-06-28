import 'package:flutter/material.dart';

/// App-wide constants for Phneak Teb.
class AppConstants {
  // App Info
  static const String appName = 'Phneak Teb';
  static const String appSubtitle = 'Divine Eye for Safer Links';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Phneak Teb is a Blue Team cybersecurity mobile app that helps users '
      'check suspicious URLs and QR codes. It is built for educational and '
      'defensive purposes only.';

  // VirusTotal API
  static const String virusTotalApiKey = 'PUT_YOUR_API_KEY_HERE';

  // Database
  static const String dbName = 'phneak_teb.db';
  static const int dbVersion = 1;
  static const String tableScanHistory = 'scan_history';
}
