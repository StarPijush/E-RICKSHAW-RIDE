import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/location/data/location_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/mock_data/mock_data.dart';
import 'package:e_go/shared/widgets/common.dart';
import 'package:e_go/shared/widgets/inputs.dart';

/// E-GO destination selection screen.
/// Fast search, suggested places in Jhargram, and recent destinations list.
class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({super.key});

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  final LocationRepository _repository = LocationRepository();
  final TextEditingController _searchController = TextEditingController();

  List<LocationSearchResult> _results = [];
  bool _isLoading = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialSuggestions();
  }

  Future<void> _loadInitialSuggestions() async {
    setState(() => _isLoading = true);
    final places = await _repository.searchPlaces('');
    if (mounted) {
      setState(() {
        _results = places;
        _isLoading = false;
      });
    }
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() {
      _currentQuery = query;
      _isLoading = true;
    });

    final places = await _repository.searchPlaces(query);
    if (mounted) {
      setState(() {
        _results = places;
        _isLoading = false;
      });
    }
  }

  void _selectDestination(LocationSearchResult result) async {
    final destination = SavedLocation(
      id: result.id,
      label: result.name,
      subtitle: result.address,
      coordinate: result.coordinate,
      type: result.type,
      createdAt: DateTime.now(),
    );

    final appState = context.read<AppState>();
    appState.setDestinationLocation(destination);

    // If pickup isn't set, default to mock current location
    if (appState.pickupLocation == null) {
      appState.setPickupLocation(
        const SavedLocation(
          id: 'pickup-default',
          label: 'Jhargram Railway Station',
          subtitle: 'Station Road, Jhargram',
          coordinate: MockData.mockCurrentLocation,
        ),
      );
    }

    // Advance to vehicle selection
    await appState.proceedToVehicleSelection();
    if (mounted) {
      Navigator.pushReplacementNamed(context, EGoRouter.vehicleSelection);
    }
  }

  void _selectRecent(SavedLocation recent) async {
    final appState = context.read<AppState>();
    appState.setDestinationLocation(recent);

    if (appState.pickupLocation == null) {
      appState.setPickupLocation(
        const SavedLocation(
          id: 'pickup-default',
          label: 'Jhargram Railway Station',
          subtitle: 'Station Road, Jhargram',
          coordinate: MockData.mockCurrentLocation,
        ),
      );
    }

    await appState.proceedToVehicleSelection();
    if (mounted) {
      Navigator.pushReplacementNamed(context, EGoRouter.vehicleSelection);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(title: const Text('Where are you going?'), elevation: 0),
      body: Column(
        children: [
          // Search input field
          Padding(
            padding: const EdgeInsets.all(EGoSpacing.lg),
            child: EGoSearchInput(
              controller: _searchController,
              hint: 'Search destination in Jhargram...',
              autofocus: true,
              onChanged: _onSearchChanged,
              onClear: () => _onSearchChanged(''),
            ),
          ),

          // Horizontal recent chips if query is empty
          if (_currentQuery.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: EGoSpacing.lg),
              child: EGoSectionHeader(title: 'Recent places'),
            ),
            const SizedBox(height: EGoSpacing.sm),
            SizedBox(
              height: 72,
              child: FutureBuilder<List<SavedLocation>>(
                future: _repository.getRecentDestinations(),
                builder: (context, snapshot) {
                  final recent = snapshot.data ?? [];
                  if (recent.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: EGoSpacing.lg,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: recent.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: EGoSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = recent[index];
                      return SizedBox(
                        width: 170,
                        child: EGoRecentDestinationChip(
                          label: item.label,
                          subtitle: item.subtitle,
                          icon: item.icon != null ? Icon(item.icon!) : null,
                          onTap: () => _selectRecent(item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: EGoSpacing.md),
            const Divider(height: 1),
          ],

          // Search Results or Suggested Places Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              EGoSpacing.lg,
              EGoSpacing.md,
              EGoSpacing.lg,
              EGoSpacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  _currentQuery.isEmpty ? 'Suggested places' : 'Search results',
                  style: EGoTypography.labelMedium.copyWith(
                    color: EGoColors.grey500,
                  ),
                ),
              ],
            ),
          ),

          // Results list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        EGoColors.brandPrimary,
                      ),
                    ),
                  )
                : _results.isEmpty
                ? const EGoEmptyState(
                    icon: Icon(Icons.location_off_outlined),
                    title: 'No places found',
                    subtitle:
                        'Try searching for Bazar, Palace, Station or Hospital',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: EGoSpacing.lg,
                      vertical: EGoSpacing.sm,
                    ),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: EGoSpacing.xs),
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(EGoSpacing.sm),
                          decoration: BoxDecoration(
                            color: EGoColors.brandPrimaryLight,
                            borderRadius: BorderRadius.circular(
                              EGoSpacing.radiusMedium,
                            ),
                          ),
                          child: Icon(
                            _iconForPlaceType(item.type),
                            color: EGoColors.brandPrimary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: EGoTypography.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          item.address,
                          style: EGoTypography.bodySmall.copyWith(
                            color: EGoColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: EGoColors.grey400,
                        ),
                        onTap: () => _selectDestination(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _iconForPlaceType(PlaceType type) {
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
        return Icons.location_on;
    }
  }
}
