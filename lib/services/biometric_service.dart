import 'package:local_auth/local_auth.dart';

/// Service for handling biometric (fingerprint/face) authentication.
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if the device supports biometric authentication.
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types on the device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate using biometric credentials.
  /// Returns true if authentication succeeds, false otherwise.
  Future<bool> authenticate() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Phneak Teb – Divine Eye',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/pattern as fallback
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Check if fingerprint is one of the available biometric types.
  Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  /// Check if face recognition is available.
  Future<bool> hasFaceId() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }
}
