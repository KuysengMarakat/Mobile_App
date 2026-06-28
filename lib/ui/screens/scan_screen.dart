import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/scan_repository.dart';
import '../../models/url_record_model.dart';
import '../../services/url_scanner_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_widgets.dart';
import '../widgets/primary_button.dart';
import '../widgets/scan_card.dart';
import '../widgets/result_badge.dart';
import 'qr_scanner_screen.dart';
import 'result_screen.dart';

/// Main scan screen: hero header, live stats, scan input, quick actions
/// and recent activity. Designed as a self-contained scrollable surface.
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
  int _totalScans = 0;
  int _safeCount = 0;
  int _threatCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final scans = await _scanRepository.getAllHistory();
      if (mounted) {
        setState(() {
          _recentScans = scans.take(4).toList();
          _totalScans = scans.length;
          _safeCount = scans.where((s) => s.status == 'safe').length;
          _threatCount =
              scans.where((s) => s.status == 'dangerous').length;
        });
      }
    } catch (_) {}
  }


  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _urlController.text = data.text!.trim();
      _snack('URL pasted from clipboard');
    } else {
      _snack('Nothing to paste from clipboard');
    }
  }

  void _snack(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _scanUrl() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isScanning = true);
    try {
      final url = Validators.sanitizeUrl(_urlController.text);
      final result = await _scannerService.scanUrl(url);
      await _scanRepository.saveScanResult(result);
      await _loadData();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      }
    } catch (e) {
      if (mounted) _snack('Scan error: ${e.toString()}', color: AppTheme.dangerRed);
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _openQrScanner() async {
    final scannedUrl = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
    if (scannedUrl != null && scannedUrl.isNotEmpty && mounted) {
      if (Validators.looksLikeUrl(scannedUrl)) {
        _urlController.text = scannedUrl;
        _scanUrl();
      } else {
        _snack('QR code does not contain a valid URL',
            color: AppTheme.warningYellow);
      }
    }
  }

  void _viewResultDetail(UrlRecordModel record) {
    final result = _scanRepository.recordToResult(record);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primaryPurple,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHero(),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingMD, 0, AppTheme.spacingMD, 0),
              child: Column(
                children: [
                  _buildScanInputCard(),
                  const SizedBox(height: 22),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildRecentScans(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 44),
      decoration: const BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BrandLogo(size: 44, showGlow: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Divine Eye for Safer Links',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const PillTag(
                  label: 'Blue Team',
                  color: AppTheme.accentGold,
                  background: Color(0x33FFFFFF),
                  icon: Icons.shield_rounded,
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Stay one step ahead of phishing.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Scan any link or QR code to check if it is safe.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildScanInputCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowLg,
        border: Border.all(color: AppTheme.hairline),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurpleSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.travel_explore_rounded,
                      color: AppTheme.primaryPurple, size: 19),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Check a URL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _urlController,
              hintText: 'Paste or type a link…',
              prefixIcon: Icons.link_rounded,
              validator: Validators.validateUrl,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              suffixWidget: IconButton(
                icon: const Icon(Icons.content_paste_rounded,
                    color: AppTheme.primaryPurple, size: 20),
                onPressed: _pasteFromClipboard,
                tooltip: 'Paste',
              ),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Scan Now',
              icon: Icons.shield_rounded,
              isLoading: _isScanning,
              width: double.infinity,
              onPressed: _isScanning ? null : _scanUrl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        StatChip(
          icon: Icons.radar_rounded,
          value: '$_totalScans',
          label: 'Total Scans',
          color: AppTheme.primaryPurple,
        ),
        const SizedBox(width: 12),
        StatChip(
          icon: Icons.verified_user_rounded,
          value: '$_safeCount',
          label: 'Safe',
          color: AppTheme.safeGreen,
        ),
        const SizedBox(width: 12),
        StatChip(
          icon: Icons.gpp_bad_rounded,
          value: '$_threatCount',
          label: 'Threats',
          color: AppTheme.dangerRed,
        ),
      ],
    );
  }


  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        ScanCard(
          title: 'Scan QR Code',
          subtitle: 'Open the camera and scan a QR code link instantly',
          icon: Icons.qr_code_scanner_rounded,
          featured: true,
          onTap: _openQrScanner,
        ),
        const SizedBox(height: 12),
        ScanCard(
          title: 'Paste & Scan',
          subtitle: 'Grab a link from your clipboard and check it',
          icon: Icons.content_paste_go_rounded,
          onTap: () async {
            await _pasteFromClipboard();
            if (_urlController.text.isNotEmpty) _scanUrl();
          },
        ),
      ],
    );
  }

  Widget _buildRecentScans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Recent Activity',
          subtitle: 'Your latest scans',
        ),
        const SizedBox(height: 12),
        if (_recentScans.isEmpty)
          _buildEmptyRecent()
        else
          ..._recentScans.map((record) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRecentItem(record),
              )),
      ],
    );
  }

  Widget _buildEmptyRecent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.hairline),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurpleSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded,
                color: AppTheme.primaryPurple, size: 26),
          ),
          const SizedBox(height: 12),
          const Text(
            'No scans yet',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Scan your first link to see it here',
            style: TextStyle(fontSize: 12.5, color: AppTheme.inkMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(UrlRecordModel record) {
    final radius = BorderRadius.circular(AppTheme.radiusMedium);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: radius,
        boxShadow: AppTheme.shadowSm,
        border: Border.all(color: AppTheme.hairline),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: () => _viewResultDetail(record),
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.getStatusSoftColor(record.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    AppTheme.getStatusIcon(record.status),
                    color: AppTheme.getStatusColor(record.status),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    record.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ResultBadge(status: record.status, showLabel: false, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
