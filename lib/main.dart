import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/app_theme.dart';
import 'ui/screens/splash_screen.dart';

/// Phneak Teb – Divine Eye for Safer Links
/// A Blue Team cybersecurity mobile app for phishing URL detection.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PhneakTebApp());
}

/// Root application widget.
class PhneakTebApp extends StatelessWidget {
  const PhneakTebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phneak Teb',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
