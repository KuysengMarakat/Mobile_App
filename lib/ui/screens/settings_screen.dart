import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/scan_repository.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'about_screen.dart';

/// Settings screen with app preferences, API mode toggle, and about section.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScanRepository _repository = ScanRepository();
  bool _useMockApi = true;
  int _totalScans = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = await _repository.getTotalScanCount();
      if (mounted) {
        setState(() {
          _useMockApi = prefs.getBool('use_mock_api') ?? true;
          _totalScans = count;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleMockApi(bool value) async {
    setState(() => _useMockApi = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_mock_api', value);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value
              ? 'Mock API mode enabled (for demo)'
              : 'Live API mode enabled'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to delete all scan history? This cannot be undone.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerRed),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.clearAllHistory();
      await _loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All scan history cleared')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppInfoCard(),
          const SizedBox(height: 16),
          _buildPreferencesSection(),
          const SizedBox(height: 16),
          _buildDataSection(),
          const SizedBox(height: 16),
          _buildSafetyTipsCard(),
          const SizedBox(height: 16),
          _buildAboutSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _buildAppInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.accentGold, width: 2),
              color: Colors.white.withOpacity(0.1),
            ),
            child: const Icon(Icons.visibility,
                color: AppTheme.accentGold, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version ${AppConstants.appVersion}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                Text(
                  '$_totalScans total scans performed',
                  style: TextStyle(
                    color: AppTheme.accentGold.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkNavy,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Mock API Mode',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text(
              'Use simulated scan results for demonstration',
              style: TextStyle(fontSize: 12),
            ),
            value: _useMockApi,
            onChanged: _toggleMockApi,
            activeColor: AppTheme.primaryPurple,
            secondary: const Icon(Icons.api, color: AppTheme.primaryPurple),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.color_lens, color: AppTheme.primaryPurple),
            title: const Text('Theme', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Royal Purple & Gold',
                style: TextStyle(fontSize: 12)),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentGold, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDataSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Data Management',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkNavy,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: AppTheme.dangerRed),
            title: const Text('Clear Scan History',
                style: TextStyle(fontSize: 14)),
            subtitle: Text('$_totalScans records stored',
                style: const TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _clearHistory,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTipsCard() {
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
            const Row(
              children: [
                Icon(Icons.lightbulb, color: AppTheme.accentGold, size: 20),
                SizedBox(width: 8),
                Text(
                  'Cybersecurity Safety Tips',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('Always verify the sender before clicking links.'),
            _buildTip('Look for HTTPS and a valid certificate.'),
            _buildTip('Be cautious of URLs with misspellings.'),
            _buildTip('Never enter credentials on unfamiliar sites.'),
            _buildTip('Use this app to scan suspicious URLs before visiting.'),
            _buildTip('Report phishing attempts to help protect others.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield, size: 14, color: AppTheme.safeGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.3),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAboutSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppTheme.primaryPurple),
            title: const Text('About Phneak Teb',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Learn more about this app',
                style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.school, color: AppTheme.primaryPurple),
            title: const Text('Project Information',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Cybersecurity Final Project',
                style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showProjectInfo(),
          ),
        ],
      ),
    );
  }

  void _showProjectInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.school, color: AppTheme.primaryPurple),
            SizedBox(width: 10),
            Text('Project Info', style: TextStyle(fontSize: 18)),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Title:', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Phneak Teb – Phishing URL Scanner'),
            SizedBox(height: 12),
            Text('Type:', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Blue Team Cybersecurity Mobile App'),
            SizedBox(height: 12),
            Text('Purpose:', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Defense, user safety, phishing protection, and ethical security awareness.'),
            SizedBox(height: 12),
            Text('Framework:', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Flutter (Dart)'),
            SizedBox(height: 12),
            Text('Features:', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('• Biometric login\n• URL scanning\n• QR code scanning\n• Local threat database\n• VirusTotal API\n• Heuristic analysis\n• SQLite history'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
