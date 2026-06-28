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
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          children: [
            _buildStatusHeader(),
            const SizedBox(height: 20),
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
    );
  }


  Widget _buildStatusHeader() {
    final color = _getStatusColor();
    final icon = _getStatusIcon();
    final title = _getStatusTitle();
    final subtitle = _getStatusSubtitle();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Status icon with circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
              border: Border.all(color: color, width: 3),
            ),
            child: Icon(icon, color: color, size: 42),
          ),
          const SizedBox(height: 16),
          // Status text
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          // Khmer label
          Text(
            result.statusKhmer,
            style: TextStyle(
              fontSize: 16,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle explanation
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
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
