import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/scan_repository.dart';
import '../../models/scan_result_model.dart';
import '../../models/url_record_model.dart';
import '../../services/url_scanner_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/scan_card.dart';
import '../widgets/result_badge.dart';
import 'qr_scanner_screen.dart';
import 'result_screen.dart';

/// Main scan screen with URL input, paste, scan, and QR code features.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _urlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UrlScannerService _scannerService = UrlScannerService();
  final ScanRepository _scanRepository = ScanRepository();

  bool _isScanning = false;
  List<UrlRecordModel> _recentScans = [];

  @override
  void initState() {
    super.initState();
    _loadRecentScans();
  }

  Future<void> _loadRecentScans() async {
    try {
      final scans = await _scanRepository.getRecentScans(limit: 3);
      if (mounted) setState(() => _recentScans = scans);
    } catch (_) {}
  }


  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _urlController.text = data.text!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URL pasted from clipboard'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nothing to paste from clipboard'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _scanUrl() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isScanning = true);

    try {
      final url = Validators.sanitizeUrl(_urlController.text);
      final result = await _scannerService.scanUrl(url);

      // Save to history
      await _scanRepository.saveScanResult(result);
      await _loadRecentScans();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan error: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }


  Future<void> _openQrScanner() async {
    final scannedUrl = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (scannedUrl != null && scannedUrl.isNotEmpty && mounted) {
      if (Validators.looksLikeUrl(scannedUrl)) {
        _urlController.text = scannedUrl;
        _scanUrl();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code does not contain a valid URL'),
            backgroundColor: AppTheme.warningYellow,
          ),
        );
      }
    }
  }

  void _viewResultDetail(UrlRecordModel record) {
    final result = _scanRepository.recordToResult(record);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(result: result),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingCard(),
          const SizedBox(height: 20),
          _buildUrlInputSection(),
          const SizedBox(height: 20),
          _buildActionCards(),
          const SizedBox(height: 24),
          _buildRecentScans(),
        ],
      ),
    );
  }


  Widget _buildGreetingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.visibility, color: AppTheme.accentGold, size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Phneak Teb',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Blue Team',
                  style: TextStyle(color: AppTheme.accentGold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Scan any URL or QR code to check for phishing threats.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildUrlInputSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter URL to Scan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkNavy,
            ),
          ),
          const SizedBox(height: 10),
          AppTextField(
            controller: _urlController,
            hintText: 'https://example.com',
            prefixIcon: Icons.link,
            validator: Validators.validateUrl,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            suffixWidget: IconButton(
              icon: const Icon(Icons.content_paste,
                  color: AppTheme.primaryPurple),
              onPressed: _pasteFromClipboard,
              tooltip: 'Paste URL',
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Scan URL',
            icon: Icons.search,
            isLoading: _isScanning,
            width: double.infinity,
            onPressed: _isScanning ? null : _scanUrl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkNavy,
          ),
        ),
        const SizedBox(height: 10),
        ScanCard(
          title: 'Scan QR Code',
          subtitle: 'Use camera to scan a QR code link',
          icon: Icons.qr_code_scanner,
          iconColor: AppTheme.accentGold,
          onTap: _openQrScanner,
        ),
        const SizedBox(height: 8),
        ScanCard(
          title: 'Paste & Scan',
          subtitle: 'Paste URL from clipboard and scan instantly',
          icon: Icons.content_paste_go,
          onTap: () async {
            await _pasteFromClipboard();
            if (_urlController.text.isNotEmpty) {
              _scanUrl();
            }
          },
        ),
      ],
    );
  }


  Widget _buildRecentScans() {
    if (_recentScans.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.mediumGray),
        ),
        child: Column(
          children: [
            Icon(Icons.history, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text(
              'No recent scans',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Scan a URL to see results here',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Scans',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkNavy,
          ),
        ),
        const SizedBox(height: 10),
        ...(_recentScans.map((record) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildRecentScanItem(record),
            ))),
      ],
    );
  }

  Widget _buildRecentScanItem(UrlRecordModel record) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: InkWell(
        onTap: () => _viewResultDetail(record),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                AppTheme.getStatusIcon(record.status),
                color: AppTheme.getStatusColor(record.status),
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  record.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              ResultBadge(status: record.status, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
