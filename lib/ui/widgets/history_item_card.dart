import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/url_record_model.dart';
import '../../utils/app_theme.dart';
import 'result_badge.dart';

/// Card widget for displaying a scan history item.
class HistoryItemCard extends StatelessWidget {
  final UrlRecordModel record;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const HistoryItemCard({
    super.key,
    required this.record,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scannedDate = DateTime.tryParse(record.scannedAt);
    final dateStr = scannedDate != null
        ? DateFormat('MMM dd, yyyy – HH:mm').format(scannedDate)
        : record.scannedAt;

    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.getStatusColor(record.status),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: 12),
              // URL and date info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status badge
              ResultBadge(status: record.status, size: 24),
              // Delete button
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: Colors.grey[400]),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
