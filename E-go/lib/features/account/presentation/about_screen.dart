import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';

/// E-GO about screen.
/// Product identity, version, operating region, and official brand presentation.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(title: const Text('About E-GO')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(EGoSpacing.xxl),
        child: Column(
          children: [
            const SizedBox(height: EGoSpacing.md),

            // Official Primary Brand Logo
            const Center(
              child: EgoLogo(variant: EgoLogoVariant.primary, height: 96),
            ),

            const SizedBox(height: EGoSpacing.md),

            Text(
              'Move your way.',
              style: EGoTypography.brandTagline.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: EGoColors.brandBlack,
              ),
            ),
            const SizedBox(height: EGoSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: EGoSpacing.md,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: EGoColors.grey100,
                borderRadius: BorderRadius.circular(EGoSpacing.radiusPill),
              ),
              child: Text(
                'v0.1.0-alpha · Jhargram, WB',
                style: EGoTypography.labelSmall.copyWith(
                  color: EGoColors.grey500,
                ),
              ),
            ),

            const SizedBox(height: EGoSpacing.xxxl),

            // Mission card
            _InfoCard(
              title: 'Our mission',
              body:
                  'E-GO is built specifically for Jhargram — connecting passengers with local Toto (E-Rickshaw) and Bike drivers through simple, transparent, and fair pricing. No hidden surge, no complicated apps.',
            ),

            const SizedBox(height: EGoSpacing.lg),

            // Operating region
            _InfoCard(
              title: 'Operating region',
              body:
                  'Currently serving Jhargram city and surrounding areas:\n\n'
                  '• Jhargram Railway Station & Bus Terminus\n'
                  '• Jhargram Rajbari & Palace Grounds\n'
                  '• Jhargram Super Speciality Hospital\n'
                  '• Jhargram DM Office & Court Complex\n'
                  '• Ghoradhara & Jamda Localities',
            ),

            const SizedBox(height: EGoSpacing.lg),

            // Vehicle types
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(EGoSpacing.lg),
              decoration: BoxDecoration(
                color: EGoColors.grey50,
                borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
                border: Border.all(color: EGoColors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vehicle categories', style: EGoTypography.titleSmall),
                  const SizedBox(height: EGoSpacing.md),
                  const _VehicleCategoryTile(
                    isToto: true,
                    title: 'Toto (E-Rickshaw)',
                    description:
                        'Electric, eco-friendly 3-wheelers. Up to 4 passengers with light luggage.',
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  const _VehicleCategoryTile(
                    isToto: false,
                    title: 'Bike Ride',
                    description:
                        'Fast single-passenger motorbike rides for quick trips across town.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: EGoSpacing.xxxl),

            // Copyright
            Text(
              '© 2026 E-GO. All rights reserved.',
              style: EGoTypography.labelSmall.copyWith(
                color: EGoColors.grey400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Made for the people of Jhargram.',
              style: EGoTypography.labelSmall.copyWith(
                color: EGoColors.grey400,
              ),
            ),
            const SizedBox(height: EGoSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(EGoSpacing.lg),
      decoration: BoxDecoration(
        color: EGoColors.grey50,
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        border: Border.all(color: EGoColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: EGoTypography.titleSmall),
          const SizedBox(height: EGoSpacing.sm),
          Text(
            body,
            style: EGoTypography.bodyMedium.copyWith(
              color: EGoColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleCategoryTile extends StatelessWidget {
  const _VehicleCategoryTile({
    required this.isToto,
    required this.title,
    required this.description,
  });

  final bool isToto;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: EGoColors.brandYellowLight,
            borderRadius: BorderRadius.circular(EGoSpacing.radiusMedium),
          ),
          child: Center(
            child: isToto
                ? const EgoLogo.icon(height: 22)
                : const Icon(
                    Icons.two_wheeler_rounded,
                    color: EGoColors.brandBlack,
                    size: 22,
                  ),
          ),
        ),
        const SizedBox(width: EGoSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: EGoTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: EGoColors.brandBlack,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: EGoTypography.bodySmall.copyWith(
                  color: EGoColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
