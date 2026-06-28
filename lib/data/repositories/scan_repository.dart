import '../../models/url_record_model.dart';
import '../../models/scan_result_model.dart';
import '../local/database_helper.dart';

/// Repository for managing scan history data operations.
class ScanRepository {
  final DatabaseHelper _dbHelper;

  ScanRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  /// Save a scan result to the database.
  Future<int> saveScanResult(ScanResultModel result) async {
    final record = UrlRecordModel(
      url: result.url,
      status: result.statusString,
      score: result.score,
      reasons: result.reasonsJson,
      source: result.source,
      scannedAt: result.scannedAt.toIso8601String(),
    );
    return await _dbHelper.insertScanRecord(record);
  }

  /// Get all scan history records.
  Future<List<UrlRecordModel>> getAllHistory() async {
    return await _dbHelper.getAllScanRecords();
  }

  /// Get scan history filtered by status.
  Future<List<UrlRecordModel>> getHistoryByStatus(String status) async {
    return await _dbHelper.getScanRecordsByStatus(status);
  }

  /// Search scan history by URL query.
  Future<List<UrlRecordModel>> searchHistory(String query) async {
    return await _dbHelper.searchScanRecords(query);
  }

  /// Get recent scan records.
  Future<List<UrlRecordModel>> getRecentScans({int limit = 5}) async {
    return await _dbHelper.getRecentScans(limit: limit);
  }

  /// Get a specific scan record by ID.
  Future<UrlRecordModel?> getScanById(int id) async {
    return await _dbHelper.getScanRecordById(id);
  }

  /// Delete a single scan record.
  Future<bool> deleteScan(int id) async {
    final result = await _dbHelper.deleteScanRecord(id);
    return result > 0;
  }

  /// Delete all scan history.
  Future<bool> clearAllHistory() async {
    final result = await _dbHelper.deleteAllScanRecords();
    return result >= 0;
  }

  /// Get the total count of scans.
  Future<int> getTotalScanCount() async {
    return await _dbHelper.getScanCount();
  }

  /// Convert a UrlRecordModel to a ScanResultModel for display.
  ScanResultModel recordToResult(UrlRecordModel record) {
    return ScanResultModel.fromRecord(
      url: record.url,
      statusStr: record.status,
      score: record.score,
      reasonsJson: record.reasons,
      source: record.source,
      scannedAt: record.scannedAt,
    );
  }
}
