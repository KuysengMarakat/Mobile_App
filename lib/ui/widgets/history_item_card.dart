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
        ? DateFormat('MMM dd, yyyy • HH:mm').format(scannedDate)
        : record.scannedAt;
    final color = AppTheme.getStatusColor(record.status);

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
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.getStatusSoftColor(record.status),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    AppTheme.getStatusIcon(record.status),
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
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
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 12, color: AppTheme.inkFaint),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dateStr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppTheme.inkFaint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ResultBadge(status: record.status, size: 22),
                    if (onDelete != null)
                      SizedBox(
                        height: 28,
                        child: TextButton(
                          onPressed: onDelete,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(40, 24),
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.inkFaint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
