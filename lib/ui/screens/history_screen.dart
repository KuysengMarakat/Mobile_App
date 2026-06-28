import 'package:flutter/material.dart';
import '../../data/repositories/scan_repository.dart';
import '../../models/url_record_model.dart';
import '../../utils/app_theme.dart';
import '../widgets/history_item_card.dart';
import 'result_screen.dart';

/// Screen displaying all scan history with search and filter capabilities.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScanRepository _repository = ScanRepository();
  final TextEditingController _searchController = TextEditingController();

  List<UrlRecordModel> _allRecords = [];
  List<UrlRecordModel> _filteredRecords = [];
  String _selectedFilter = 'all'; // all, safe, warning, dangerous
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final records = await _repository.getAllHistory();
      if (mounted) {
        setState(() {
          _allRecords = records;
          _applyFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  void _applyFilter() {
    List<UrlRecordModel> filtered;
    if (_selectedFilter == 'all') {
      filtered = List.from(_allRecords);
    } else {
      filtered =
          _allRecords.where((r) => r.status == _selectedFilter).toList();
    }

    // Apply search query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered =
          filtered.where((r) => r.url.toLowerCase().contains(query)).toList();
    }

    setState(() => _filteredRecords = filtered);
  }

  void _onSearchChanged(String value) {
    _applyFilter();
  }

  void _setFilter(String filter) {
    setState(() => _selectedFilter = filter);
    _applyFilter();
  }

  Future<void> _deleteRecord(UrlRecordModel record) async {
    if (record.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Scan'),
        content: const Text('Remove this scan from history?'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.deleteScan(record.id!);
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan record deleted')),
        );
      }
    }
  }


  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to delete all scan history? This action cannot be undone.',
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
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All history cleared')),
        );
      }
    }
  }

  void _viewResult(UrlRecordModel record) {
    final result = _repository.recordToResult(record);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.canvas,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterChips(),
            const SizedBox(height: 4),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurpleSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.history_rounded,
                color: AppTheme.primaryPurple, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'All your past scans',
                  style: TextStyle(fontSize: 12.5, color: AppTheme.inkMuted),
                ),
              ],
            ),
          ),
          if (_allRecords.isNotEmpty)
            IconButton(
              onPressed: _clearAllHistory,
              icon: const Icon(Icons.delete_sweep_rounded),
              color: AppTheme.dangerRed,
              tooltip: 'Clear all',
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.ink),
        cursorColor: AppTheme.primaryPurple,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search URLs…',
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppTheme.inkFaint, size: 21),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppTheme.inkFaint,
                  onPressed: () {
                    _searchController.clear();
                    _applyFilter();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Safe', 'safe', AppTheme.safeGreen),
            const SizedBox(width: 8),
            _buildFilterChip('Warning', 'warning', AppTheme.warningYellow),
            const SizedBox(width: 8),
            _buildFilterChip('Dangerous', 'dangerous', AppTheme.dangerRed),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter, [Color? color]) {
    final isSelected = _selectedFilter == filter;
    final c = color ?? AppTheme.primaryPurple;
    return GestureDetector(
      onTap: () => _setFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? c : AppTheme.surface,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? c : AppTheme.hairline,
          ),
          boxShadow: isSelected ? AppTheme.shadowSm : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppTheme.inkMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryPurple),
      );
    }

    if (_allRecords.isEmpty) {
      return _buildEmptyState();
    }

    if (_filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No results found',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      color: AppTheme.primaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
        itemCount: _filteredRecords.length,
        itemBuilder: (context, index) {
          final record = _filteredRecords[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HistoryItemCard(
              record: record,
              onTap: () => _viewResult(record),
              onDelete: () => _deleteRecord(record),
            ),
          );
        },
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 40,
                color: AppTheme.primaryPurple.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Scan History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkNavy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your scanned URLs will appear here.\nStart by scanning a link on the Scan tab.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
