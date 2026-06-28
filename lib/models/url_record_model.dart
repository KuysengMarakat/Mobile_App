/// Model representing a URL record stored in the scan history database.
class UrlRecordModel {
  final int? id;
  final String url;
  final String status; // 'safe', 'warning', 'dangerous'
  final int score; // 0-100, higher = more dangerous
  final String reasons; // JSON-encoded list of reason strings
  final String source; // 'local', 'api', 'heuristic'
  final String scannedAt; // ISO 8601 date string

  UrlRecordModel({
    this.id,
    required this.url,
    required this.status,
    required this.score,
    required this.reasons,
    required this.source,
    required this.scannedAt,
  });

  /// Convert to map for SQLite insertion.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'url': url,
      'status': status,
      'score': score,
      'reasons': reasons,
      'source': source,
      'scannedAt': scannedAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Create from SQLite row map.
  factory UrlRecordModel.fromMap(Map<String, dynamic> map) {
    return UrlRecordModel(
      id: map['id'] as int?,
      url: map['url'] as String,
      status: map['status'] as String,
      score: map['score'] as int,
      reasons: map['reasons'] as String,
      source: map['source'] as String,
      scannedAt: map['scannedAt'] as String,
    );
  }

  /// Create a copy with updated fields.
  UrlRecordModel copyWith({
    int? id,
    String? url,
    String? status,
    int? score,
    String? reasons,
    String? source,
    String? scannedAt,
  }) {
    return UrlRecordModel(
      id: id ?? this.id,
      url: url ?? this.url,
      status: status ?? this.status,
      score: score ?? this.score,
      reasons: reasons ?? this.reasons,
      source: source ?? this.source,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  String toString() =>
      'UrlRecordModel(id: $id, url: $url, status: $status, score: $score)';
}
