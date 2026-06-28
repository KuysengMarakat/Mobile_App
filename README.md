# Phneak Teb – Phishing URL Scanner

> "Phneak Teb" means **"Divine Eye"** in Khmer. The app protects users from hidden online dangers by scanning links and QR codes to detect phishing or malicious URLs.

## Overview

A **Blue Team** cybersecurity mobile application built with Flutter for educational and defensive purposes. This app helps users check suspicious URLs and QR codes to identify phishing threats.

## Features

- **Biometric Authentication** – Fingerprint/Face ID login
- **URL Scanning** – Paste or type URLs to scan for threats
- **QR Code Scanning** – Use camera to scan QR codes containing URLs
- **Multi-layer Detection:**
  - Local threat database (offline)
  - Heuristic pattern analysis
  - VirusTotal API integration
- **Scan History** – SQLite-stored history with search and filter
- **Result Details** – Clear safe/warning/dangerous status with explanations
- **Safety Tips** – Cybersecurity awareness education

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter (Dart) |
| Auth | local_auth (Biometric) |
| QR Scanner | mobile_scanner |
| Database | SQLite (sqflite) |
| API | VirusTotal REST API v3 |
| Architecture | Layered (Repository Pattern) |
| Design | Material 3 |

## Project Structure

```
lib/
  main.dart
  data/
    repositories/    # Data access layer
    local/           # SQLite & local JSON loader
    remote/          # Remote API clients
  models/            # Data models
  ui/
    screens/         # App screens
    widgets/         # Reusable widgets
  services/          # Business logic services
  utils/             # Constants, theme, validators
```

## Getting Started

1. Ensure Flutter SDK is installed (>=3.2.0)
2. Run `flutter pub get`
3. Run `flutter run`

## Brand Colors

- **Primary:** Royal Purple `#6B1F8A`
- **Accent:** Gold `#FFD700`

## Ethical Statement

This application is designed exclusively for defensive cybersecurity education. It does NOT perform hacking, credential theft, exploitation, or any offensive security actions.

---

*Cybersecurity Final Project*
