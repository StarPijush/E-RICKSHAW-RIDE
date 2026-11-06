import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/location/data/location_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/shared/widgets/common.dart';

/// E-GO location search delegate for destination search.
class EGoLocationSearchDelegate extends SearchDelegate<LocationSearchResult?> {
  EGoLocationSearchDelegate({required this.repository});

  final LocationRepository repository;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: EGoColors.grey500),
          onPressed: () => query = '',
          tooltip: 'Clear',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: EGoColors.onSurface),
      onPressed: () => close(context, null),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<List<LocationSearchResult>>(
      future: repository.searchPlaces(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  EGoColors.brandPrimary,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return EGoEmptyState(
            icon: const Icon(Icons.error_outline),
            title: 'Search failed',
            subtitle: 'Please try again',
          );
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty && query.isNotEmpty) {
          return EGoEmptyState(
            icon: const Icon(Icons.location_off),
            title: 'No results found',
            subtitle: 'Try a different search term',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(EGoSpacing.lg),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: EGoSpacing.xs),
          itemBuilder: (context, index) {
            final result = results[index];
            return _LocationSearchResultTile(
              result: result,
              onTap: () => close(context, result),
            );
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: EGoColors.white,
        foregroundColor: EGoColors.onSurface,
        elevation: 0,
        surfaceTintColor: EGoColors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: EGoTypography.bodyMedium.copyWith(color: EGoColors.grey500),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class _LocationSearchResultTile extends StatelessWidget {
  const _LocationSearchResultTile({required this.result, required this.onTap});

  final LocationSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconForType(result.type);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(EGoSpacing.sm),
          decoration: BoxDecoration(
            color: EGoColors.brandPrimaryLight,
            borderRadius: BorderRadius.circular(EGoSpacing.radiusMedium),
          ),
          child: Icon(
            iconData,
            color: EGoColors.brandPrimary,
            size: EGoSpacing.iconMedium,
          ),
        ),
        title: Text(
          result.name,
          style: EGoTypography.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          result.address,
          style: EGoTypography.bodySmall.copyWith(
            color: EGoColors.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: EGoColors.grey400,
          size: EGoSpacing.iconMedium,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        ),
        tileColor: EGoColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.md,
          vertical: EGoSpacing.xs,
        ),
      ),
    );
  }

  IconData _getIconForType(PlaceType type) {
    switch (type) {
      case PlaceType.market:
        return Icons.store;
      case PlaceType.transport:
        return Icons.train;
      case PlaceType.landmark:
        return Icons.account_balance;
      case PlaceType.hospital:
        return Icons.local_hospital;
      case PlaceType.education:
        return Icons.school;
      case PlaceType.residential:
        return Icons.home;
      case PlaceType.other:
        return Icons.place;
    }
  }
}
