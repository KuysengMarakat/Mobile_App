import 'package:flutter/material.dart';
import '../../services/biometric_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../widgets/app_widgets.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

/// Premium login screen with animated gradient, glowing brand mark,
/// and glass-style authentication actions.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticating = false;
  bool _biometricAvailable = false;

  late final AnimationController _entryController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));

    _bgController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _entryController.forward();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await _biometricService.isBiometricAvailable();
    if (mounted) setState(() => _biometricAvailable = available);
  }


  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);
    try {
      final success = await _biometricService.authenticate();
      if (success && mounted) {
        _navigateToHome();
      } else if (mounted) {
        _showError('Authentication failed. Please try again.');
      }
    } catch (e) {
      if (mounted) _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.dangerRed,
      ),
    );
  }

  void _loginAsDemo() => _navigateToHome();

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, a, __) => const HomeScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(
          opacity: a,
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _bgController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient backdrop
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppTheme.splashGradient),
            ),
          ),
          _buildGlowOrbs(),
          // Foreground content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppTheme.spacingLG),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      const BrandLogo(size: 124),
                      const SizedBox(height: 28),
                      _buildAppName(),
                      const SizedBox(height: 10),
                      _buildSubtitle(),
                      const Spacer(flex: 3),
                      _buildLoginCard(),
                      const Spacer(flex: 1),
                      _buildFooter(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrbs() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        final t = _bgController.value;
        return Stack(
          children: [
            Positioned(
              top: -80 + (t * 30),
              right: -60,
              child: _orb(220, AppTheme.accentGold.withOpacity(0.16)),
            ),
            Positioned(
              bottom: 40 - (t * 30),
              left: -70,
              child: _orb(260, AppTheme.primaryPurpleLight.withOpacity(0.35)),
            ),
          ],
        );
      },
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }


  Widget _buildAppName() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Color(0xFFF1E3FF)],
      ).createShader(bounds),
      child: const Text(
        AppConstants.appName,
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      children: [
        Text(
          AppConstants.appSubtitle,
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.accentGold.withOpacity(0.95),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ភ្នែកទេព • Divine Eye',
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Text(
            _biometricAvailable
                ? 'Unlock with your fingerprint to continue'
                : 'Enter the app to start scanning',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          if (_biometricAvailable) ...[
            PrimaryButton(
              label: 'Login with Fingerprint',
              icon: Icons.fingerprint_rounded,
              isLoading: _isAuthenticating,
              gradient: AppTheme.goldGradient,
              foregroundColor: AppTheme.primaryPurpleDark,
              width: double.infinity,
              onPressed: _authenticateWithBiometric,
            ),
            const SizedBox(height: 12),
          ],
          PrimaryButton(
            label: _biometricAvailable
                ? 'Continue as Demo'
                : 'Enter App (Demo Mode)',
            icon: Icons.arrow_forward_rounded,
            isOutlined: _biometricAvailable,
            gradient: _biometricAvailable ? null : AppTheme.goldGradient,
            foregroundColor:
                _biometricAvailable ? Colors.white : AppTheme.primaryPurpleDark,
            width: double.infinity,
            onPressed: _loginAsDemo,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_rounded,
                color: Colors.white.withOpacity(0.5), size: 15),
            const SizedBox(width: 6),
            Text(
              'Blue Team Cybersecurity',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'For educational & defensive purposes only',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
