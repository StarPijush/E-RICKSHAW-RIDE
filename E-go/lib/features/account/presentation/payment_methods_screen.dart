import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO payment methods screen.
/// Cash and demo UPI payment options.
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentMethod = appState.paymentMethod;

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(title: const Text('Payment methods')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(EGoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferred payment',
              style: EGoTypography.labelMedium.copyWith(
                color: EGoColors.grey500,
              ),
            ),
            const SizedBox(height: EGoSpacing.sm),

            // Cash option
            _PaymentOptionCard(
              title: 'Cash',
              subtitle: 'Pay directly to your rider or toto driver',
              icon: Icons.money,
              iconColor: EGoColors.success,
              isSelected: currentMethod == PaymentMethod.cash,
              badgeText: 'Active',
              badgeColor: EGoColors.successLight,
              badgeTextColor: EGoColors.success,
              onTap: () {
                context.read<AppState>().setPaymentMethod(PaymentMethod.cash);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment set to Cash'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            const SizedBox(height: EGoSpacing.md),

            // UPI Demo option
            _PaymentOptionCard(
              title: 'UPI (GPay, PhonePe, Paytm)',
              subtitle: 'Pay via UPI QR code upon arrival',
              icon: Icons.qr_code_2,
              iconColor: EGoColors.brandBlack,
              isSelected: currentMethod == PaymentMethod.upi,
              badgeText: 'Demo Mode',
              badgeColor: EGoColors.brandYellowLight,
              badgeTextColor: EGoColors.brandBlack,
              onTap: () {
                context.read<AppState>().setPaymentMethod(PaymentMethod.upi);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment set to UPI (Simulated)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            const SizedBox(height: EGoSpacing.xl),

            // Demo disclaimer notice
            Container(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              decoration: BoxDecoration(
                color: EGoColors.warningLight,
                borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
                border: Border.all(
                  color: EGoColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: EGoColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: EGoSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Notice',
                          style: EGoTypography.titleSmall.copyWith(
                            color: EGoColors.grey900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'In this preview release of E-GO, payments are simulated. No real monetary transactions or banking APIs are connected.',
                          style: EGoTypography.bodySmall.copyWith(
                            color: EGoColors.grey800,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(EGoSpacing.lg),
          child: EGoPrimaryButton(
            onPressed: () => Navigator.pop(context),
            label: 'Done',
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  const _PaymentOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(EGoSpacing.lg),
        decoration: BoxDecoration(
          color: EGoColors.surface,
          borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
          border: Border.all(
            color: isSelected
                ? EGoColors.brandPrimary
                : EGoColors.outlineVariant,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: EGoColors.brandPrimary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(EGoSpacing.md),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(EGoSpacing.radiusMedium),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: EGoSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: EGoTypography.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: EGoSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(
                            EGoSpacing.radiusSmall,
                          ),
                        ),
                        child: Text(
                          badgeText,
                          style: EGoTypography.labelSmall.copyWith(
                            color: badgeTextColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: EGoTypography.bodySmall.copyWith(
                      color: EGoColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? EGoColors.brandPrimary : EGoColors.grey400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
