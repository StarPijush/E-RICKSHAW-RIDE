import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/location/data/location_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/shared/widgets/index.dart';

/// Bottom sheet showing recent destinations.
class EGoRecentDestinationsBottomSheet extends StatelessWidget {
  const EGoRecentDestinationsBottomSheet({
    super.key,
    required this.onDestinationSelected,
    this.onSeeAll,
  });

  final ValueChanged<SavedLocation> onDestinationSelected;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: EGoColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(EGoSpacing.radiusXLarge),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: EGoSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: EGoColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(EGoSpacing.lg),
                child: EGoSectionHeader(
                  title: 'Recent destinations',
                  action: onSeeAll,
                  actionLabel: onSeeAll != null ? 'See all' : null,
                ),
              ),
              const Divider(height: 1),
              // List
              Expanded(
                child: FutureBuilder<List<SavedLocation>>(
                  future: LocationRepository().getRecentDestinations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            EGoColors.brandPrimary,
                          ),
                        ),
                      );
                    }

                    final destinations = snapshot.data ?? [];

                    if (destinations.isEmpty) {
                      return EGoEmptyState(
                        icon: const Icon(Icons.history),
                        title: 'No recent destinations',
                        subtitle: 'Your recent destinations will appear here',
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(EGoSpacing.lg),
                      itemCount: destinations.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: EGoSpacing.sm),
                      itemBuilder: (context, index) {
                        final destination = destinations[index];
                        return EGoRecentDestinationChip(
                          label: destination.label,
                          subtitle: destination.subtitle,
                          icon: destination.icon != null
                              ? Icon(destination.icon!)
                              : null,
                          onTap: () => onDestinationSelected(destination),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
