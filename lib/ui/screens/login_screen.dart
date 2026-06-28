import 'package:flutter/material.dart';
import '../../services/biometric_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

/// Login screen with biometric authentication and demo login option.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticating = false;
  bool _biometricAvailable = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await _biometricService.isBiometricAvailable();
    if (mounted) {
      setState(() => _biometricAvailable = available);
    }
  }


  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    try {
      final success = await _biometricService.authenticate();
      if (success && mounted) {
        _navigateToHome();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication failed. Please try again.'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  void _loginAsDemo() {
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLG),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  _buildLogo(),
                  const SizedBox(height: 24),
                  _buildAppName(),
                  const SizedBox(height: 8),
                  _buildSubtitle(),
                  const Spacer(flex: 2),
                  _buildLoginButtons(),
                  const Spacer(flex: 1),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentGold, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shield, size: 64, color: Colors.white24),
            Icon(Icons.visibility, size: 40, color: AppTheme.accentGold),
          ],
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return const Text(
      AppConstants.appName,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      AppConstants.appSubtitle,
      style: TextStyle(
        fontSize: 15,
        color: AppTheme.accentGold,
        fontWeight: FontWeight.w400,
      ),
    );
  }


  Widget _buildLoginButtons() {
    return Column(
      children: [
        // Biometric login button
        if (_biometricAvailable)
          PrimaryButton(
            label: 'Login with Fingerprint',
            icon: Icons.fingerprint,
            isLoading: _isAuthenticating,
            backgroundColor: AppTheme.accentGold,
            foregroundColor: AppTheme.darkNavy,
            width: double.infinity,
            onPressed: _authenticateWithBiometric,
          ),
        if (_biometricAvailable) const SizedBox(height: 16),
        // Demo login button
        PrimaryButton(
          label: _biometricAvailable
              ? 'Demo Login (For Presentation)'
              : 'Enter App (Demo Mode)',
          icon: Icons.login,
          isOutlined: _biometricAvailable,
          backgroundColor:
              _biometricAvailable ? Colors.white : AppTheme.accentGold,
          foregroundColor: _biometricAvailable
              ? Colors.white
              : AppTheme.darkNavy,
          width: double.infinity,
          onPressed: _loginAsDemo,
        ),
        if (!_biometricAvailable) ...[
          const SizedBox(height: 12),
          Text(
            'Biometric not available on this device',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Icon(
          Icons.security,
          color: Colors.white.withOpacity(0.4),
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          'Blue Team Cybersecurity App',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
        Text(
          'For educational and defensive purposes only',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
