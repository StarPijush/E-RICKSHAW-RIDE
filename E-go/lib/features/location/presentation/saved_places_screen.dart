import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/mock_data/mock_data.dart';
import 'package:e_go/shared/widgets/buttons.dart';
import 'package:e_go/shared/widgets/common.dart';

/// E-GO saved places screen.
/// Manage Home, Work, and favorite local destinations in Jhargram.
class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  late List<SavedPlace> _places;

  @override
  void initState() {
    super.initState();
    _places = [
      const SavedPlace(
        id: 'home',
        label: 'Home',
        address: 'Ward No. 8, Ghoradhara, Jhargram',
        icon: Icons.home,
        type: SavedPlaceType.home,
        coordinate: LatLng(22.4580, 86.9080),
      ),
      const SavedPlace(
        id: 'work',
        label: 'Work / Office',
        address: 'Near District Collectorate, Jhargram',
        icon: Icons.work,
        type: SavedPlaceType.work,
        coordinate: LatLng(22.4510, 86.8990),
      ),
      const SavedPlace(
        id: 'fav-1',
        label: 'Jhargram Raj Palace',
        address: 'Palace Road, Old Jhargram',
        icon: Icons.bookmark,
        type: SavedPlaceType.other,
        coordinate: LatLng(22.4480, 86.8950),
      ),
    ];
  }

  void _addNewPlace() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Add Favorite Place'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Label (e.g. Gym, Library, Friend\'s House)',
              ),
            ),
            const SizedBox(height: EGoSpacing.md),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address in Jhargram',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  _places.add(
                    SavedPlace(
                      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
                      label: titleController.text.trim(),
                      address: addressController.text.trim().isEmpty
                          ? 'Jhargram area'
                          : addressController.text.trim(),
                      icon: Icons.place,
                      type: SavedPlaceType.other,
                      coordinate: MockData.jhargramCenter,
                    ),
                  );
                });
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Place saved successfully!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _removePlace(String id) {
    setState(() {
      _places.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Place removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(title: const Text('Saved places')),
      body: _places.isEmpty
          ? EGoEmptyState(
              icon: const Icon(Icons.bookmark_border),
              title: 'No saved places yet',
              subtitle:
                  'Save Home, Work and frequent destinations for faster booking',
              actionLabel: 'Add place',
              onAction: _addNewPlace,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              itemCount: _places.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: EGoSpacing.sm),
              itemBuilder: (context, index) {
                final place = _places[index];
                return Dismissible(
                  key: Key(place.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: EGoSpacing.xl),
                    decoration: BoxDecoration(
                      color: EGoColors.error,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _removePlace(place.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: EGoColors.surface,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                      border: Border.all(color: EGoColors.outlineVariant),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(EGoSpacing.sm),
                        decoration: BoxDecoration(
                          color: EGoColors.brandPrimaryLight,
                          borderRadius: BorderRadius.circular(
                            EGoSpacing.radiusMedium,
                          ),
                        ),
                        child: Icon(
                          place.icon,
                          color: EGoColors.brandPrimary,
                          size: 22,
                        ),
                      ),
                      title: Text(place.label, style: EGoTypography.titleSmall),
                      subtitle: Text(
                        place.address,
                        style: EGoTypography.bodySmall.copyWith(
                          color: EGoColors.onSurfaceVariant,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: EGoColors.grey400,
                          size: 20,
                        ),
                        onPressed: () => _removePlace(place.id),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(EGoSpacing.lg),
          child: EGoPrimaryButton(
            onPressed: _addNewPlace,
            label: 'Add a new place',
            icon: const Icon(Icons.add, color: EGoColors.brandBlack),
          ),
        ),
      ),
    );
  }
}
