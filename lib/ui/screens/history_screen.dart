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
  bool _isSearching = false;

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

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _applyFilter();
      }
    });
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
    return Column(
      children: [
        // Search bar and actions
        if (_isSearching) _buildSearchBar(),
        // Filter chips
        _buildFilterChips(),
        // Content
        Expanded(child: _buildContent()),
      ],
    );
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search URLs...',
          prefixIcon:
              const Icon(Icons.search, color: AppTheme.primaryPurple),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _toggleSearch,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            borderSide: BorderSide(color: AppTheme.mediumGray),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Safe', 'safe', AppTheme.safeGreen),
          const SizedBox(width: 8),
          _buildFilterChip('Warning', 'warning', AppTheme.warningYellow),
          const SizedBox(width: 8),
          _buildFilterChip('Danger', 'dangerous', AppTheme.dangerRed),
          const Spacer(),
          // Action icons
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            onPressed: _toggleSearch,
            color: AppTheme.primaryPurple,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, size: 22),
            onPressed: _allRecords.isEmpty ? null : _clearAllHistory,
            color: AppTheme.dangerRed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterChip(String label, String filter, [Color? color]) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => _setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppTheme.primaryPurple).withOpacity(0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? AppTheme.primaryPurple)
                : AppTheme.mediumGray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? (color ?? AppTheme.primaryPurple)
                : Colors.grey[600],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _filteredRecords.length,
        itemBuilder: (context, index) {
          final record = _filteredRecords[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
