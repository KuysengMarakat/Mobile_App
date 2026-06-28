import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

/// About screen explaining the app's purpose and ethical use.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            _buildFeaturesCard(),
            const SizedBox(height: 16),
            _buildEthicsCard(),
            const SizedBox(height: 16),
            _buildTechStackCard(),
            const SizedBox(height: 24),
            _buildFooter(),
          ],
        ),
      ),
    );
  }


  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            border: Border.all(color: AppTheme.accentGold, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shield, size: 52, color: Colors.white24),
              Icon(Icons.visibility, size: 34, color: AppTheme.accentGold),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          AppConstants.appSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version ${AppConstants.appVersion}',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return _buildCard(
      icon: Icons.info_outline,
      title: 'What is Phneak Teb?',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"Phneak Teb" means "Divine Eye" in Khmer.',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.primaryPurple,
            ),
          ),
          SizedBox(height: 10),
          Text(
            AppConstants.appDescription,
            style: TextStyle(fontSize: 13, height: 1.5, color: AppTheme.darkGray),
          ),
        ],
      ),
    );
  }


  Widget _buildFeaturesCard() {
    return _buildCard(
      icon: Icons.star_outline,
      title: 'Key Features',
      child: Column(
        children: [
          _buildFeatureItem(Icons.fingerprint, 'Biometric Authentication'),
          _buildFeatureItem(Icons.link, 'URL Phishing Detection'),
          _buildFeatureItem(Icons.qr_code_scanner, 'QR Code Scanning'),
          _buildFeatureItem(Icons.storage, 'Local Threat Database'),
          _buildFeatureItem(Icons.cloud, 'VirusTotal API Integration'),
          _buildFeatureItem(Icons.analytics, 'Heuristic Analysis'),
          _buildFeatureItem(Icons.history, 'Scan History with SQLite'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryPurple),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildEthicsCard() {
    return _buildCard(
      icon: Icons.gavel,
      title: 'Ethical Use Statement',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This is a Blue Team defensive cybersecurity application. '
            'It is designed exclusively for:',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          SizedBox(height: 10),
          _EthicPoint(text: 'Educating users about phishing threats'),
          _EthicPoint(text: 'Protecting users from malicious URLs'),
          _EthicPoint(text: 'Promoting cybersecurity awareness'),
          _EthicPoint(text: 'Academic and research purposes'),
          SizedBox(height: 10),
          Text(
            'This app does NOT:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.dangerRed,
            ),
          ),
          SizedBox(height: 6),
          _EthicPoint(text: 'Perform hacking or exploitation', isDanger: true),
          _EthicPoint(text: 'Steal credentials or private data', isDanger: true),
          _EthicPoint(text: 'Create or distribute malware', isDanger: true),
          _EthicPoint(text: 'Conduct unauthorized access', isDanger: true),
        ],
      ),
    );
  }


  Widget _buildTechStackCard() {
    return _buildCard(
      icon: Icons.code,
      title: 'Technology Stack',
      child: Column(
        children: [
          _buildTechRow('Framework', 'Flutter (Dart)'),
          _buildTechRow('Auth', 'local_auth (Biometric)'),
          _buildTechRow('Scanner', 'mobile_scanner'),
          _buildTechRow('Database', 'SQLite (sqflite)'),
          _buildTechRow('API', 'VirusTotal REST API v3'),
          _buildTechRow('Architecture', 'Layered (Repository Pattern)'),
          _buildTechRow('Design', 'Material 3'),
        ],
      ),
    );
  }

  Widget _buildTechRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 12),
        const Icon(Icons.security, color: AppTheme.primaryPurple, size: 24),
        const SizedBox(height: 8),
        Text(
          'Built with security in mind',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Cybersecurity Final Project',
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}


/// Helper widget for ethical use bullet points.
class _EthicPoint extends StatelessWidget {
  final String text;
  final bool isDanger;

  const _EthicPoint({required this.text, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isDanger ? Icons.close : Icons.check_circle_outline,
            size: 16,
            color: isDanger ? AppTheme.dangerRed : AppTheme.safeGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDanger ? AppTheme.dangerRed : AppTheme.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
