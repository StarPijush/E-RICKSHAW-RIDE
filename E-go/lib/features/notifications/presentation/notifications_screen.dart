import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/common.dart';

/// E-GO notifications screen.
/// Displays ride updates, promos, and system notices.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final notifications = appState.notifications;

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                context.read<AppState>().markAllNotificationsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EGoEmptyState(
              icon: Icon(Icons.notifications_off_outlined),
              title: 'No notifications',
              subtitle: 'We\'ll notify you about your rides and offers here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              itemCount: notifications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: EGoSpacing.sm),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return InkWell(
                  onTap: () {
                    context.read<AppState>().markNotificationRead(item.id);
                  },
                  borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
                  child: Container(
                    padding: const EdgeInsets.all(EGoSpacing.lg),
                    decoration: BoxDecoration(
                      color: item.isRead
                          ? EGoColors.surface
                          : EGoColors.brandPrimaryLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                      border: Border.all(
                        color: item.isRead
                            ? EGoColors.outlineVariant
                            : EGoColors.brandPrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(EGoSpacing.sm),
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? EGoColors.grey100
                                : EGoColors.brandPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.iconData,
                            size: 18,
                            color: item.isRead
                                ? EGoColors.grey600
                                : EGoColors.white,
                          ),
                        ),
                        const SizedBox(width: EGoSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item.title,
                                      style: EGoTypography.titleSmall.copyWith(
                                        fontWeight: item.isRead
                                            ? FontWeight.w500
                                            : FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (!item.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: EGoColors.brandPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.body,
                                style: EGoTypography.bodyMedium.copyWith(
                                  color: EGoColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: EGoSpacing.xs),
                              Text(
                                _timeAgo(item.createdAt),
                                style: EGoTypography.labelSmall.copyWith(
                                  color: EGoColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
