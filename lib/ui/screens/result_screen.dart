import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/scan_result_model.dart';
import '../../utils/app_theme.dart';
import 'package:intl/intl.dart';

/// Screen displaying the detailed result of a URL scan.
class ResultScreen extends StatelessWidget {
  final ScanResultModel result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHero(context),
          Transform.translate(
            offset: const Offset(0, -26),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  _buildUrlCard(),
                  const SizedBox(height: 16),
                  _buildDetailsCard(),
                  const SizedBox(height: 16),
                  _buildReasonsCard(),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final color = _getStatusColor();
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, Color.lerp(color, Colors.black, 0.28)!],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 46),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
            const SizedBox(height: 4),
            // Badge with score ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 104,
                  height: 104,
                  child: CircularProgressIndicator(
                    value: result.score / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withOpacity(0.22),
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.18),
                  ),
                  child: Icon(_getStatusIcon(), color: Colors.white, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _getStatusTitle(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${result.statusText} • ${result.statusKhmer}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                _getStatusSubtitle(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.78),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUrlCard() {
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
                const Icon(Icons.link, color: AppTheme.primaryPurple, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Scanned URL',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softGray,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                result.url,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  color: AppTheme.darkNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    final dateStr = DateFormat('MMMM dd, yyyy – HH:mm:ss')
        .format(result.scannedAt);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow('Status', result.statusText, _getStatusColor()),
            const Divider(height: 20),
            _buildDetailRow('Threat Score', '${result.score}/100', null),
            const Divider(height: 20),
            _buildDetailRow('Source', _getSourceLabel(), null),
            const Divider(height: 20),
            _buildDetailRow('Scanned At', dateStr, null),
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.darkNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildReasonsCard() {
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
                Icon(Icons.info_outline, color: AppTheme.primaryPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Analysis Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...result.reasons.map((reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 6,
                        color: _getStatusColor().withOpacity(0.7),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }


  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Scan another link
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.search),
            label: const Text('Scan Another Link'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Copy result
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copyResult(context),
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                  side: const BorderSide(color: AppTheme.primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Share warning
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareResult(),
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                  side: const BorderSide(color: AppTheme.primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  void _copyResult(BuildContext context) {
    final text = _getShareText();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Result copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareResult() {
    final text = _getShareText();
    Share.share(text, subject: 'Phneak Teb - URL Scan Result');
  }

  String _getShareText() {
    final status = result.statusText.toUpperCase();
    return '🔍 Phneak Teb Scan Result\n'
        '━━━━━━━━━━━━━━━━━\n'
        'URL: ${result.url}\n'
        'Status: $status ${result.statusKhmer}\n'
        'Score: ${result.score}/100\n'
        'Source: ${_getSourceLabel()}\n\n'
        'Reasons:\n${result.reasons.map((r) => '• $r').join('\n')}\n\n'
        '🛡️ Stay safe online – Phneak Teb (Divine Eye)';
  }

  // Helper methods
  Color _getStatusColor() {
    switch (result.status) {
      case ScanStatus.safe:
        return AppTheme.safeGreen;
      case ScanStatus.warning:
        return AppTheme.warningYellow;
      case ScanStatus.dangerous:
        return AppTheme.dangerRed;
    }
  }

  IconData _getStatusIcon() {
    switch (result.status) {
      case ScanStatus.safe:
        return Icons.verified_user;
      case ScanStatus.warning:
        return Icons.warning_amber_rounded;
      case ScanStatus.dangerous:
        return Icons.gpp_bad;
    }
  }

  String _getStatusTitle() {
    switch (result.status) {
      case ScanStatus.safe:
        return 'This link looks safe';
      case ScanStatus.warning:
        return 'Be careful with this link';
      case ScanStatus.dangerous:
        return 'Dangerous link detected!';
    }
  }

  String _getStatusSubtitle() {
    switch (result.status) {
      case ScanStatus.safe:
        return 'No known threats detected. This URL appears to be safe.';
      case ScanStatus.warning:
        return 'Some suspicious patterns were found. Proceed with caution.';
      case ScanStatus.dangerous:
        return 'This URL matches known phishing or malicious patterns. Do not visit.';
    }
  }

  String _getSourceLabel() {
    switch (result.source) {
      case 'local':
        return 'Local Database';
      case 'api':
        return 'VirusTotal API';
      case 'heuristic':
        return 'Heuristic Analysis';
      default:
        return result.source;
    }
  }
}
