import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/mock_data/mock_data.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO help & support screen.
/// Frequently asked questions and in-app support assistance.
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _issueController = TextEditingController();

  void _showReportIssueDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe your concern or feedback regarding your ride experience in Jhargram:',
              style: TextStyle(fontSize: 13, color: EGoColors.grey600),
            ),
            const SizedBox(height: EGoSpacing.md),
            TextField(
              controller: _issueController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'e.g. Driver requested excess cash, app map issue, etc.',
                border: OutlineInputBorder(),
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
              if (_issueController.text.trim().isNotEmpty) {
                Navigator.pop(dialogCtx);
                _issueController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Issue report submitted! Our support team will review it.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(EGoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Support Card
            Container(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [EGoColors.brandYellow, EGoColors.brandYellowDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.support_agent,
                        color: EGoColors.brandBlack,
                        size: 28,
                      ),
                      const SizedBox(width: EGoSpacing.md),
                      Text(
                        'E-GO Support Team',
                        style: EGoTypography.titleMedium.copyWith(
                          color: EGoColors.brandBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.sm),
                  Text(
                    'We are here to assist with your rides, safety, and payments in Jhargram.',
                    style: EGoTypography.bodyMedium.copyWith(
                      color: EGoColors.brandBlack.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  EGoSecondaryButton(
                    onPressed: _showReportIssueDialog,
                    label: 'Report an issue',
                    height: 40,
                  ),
                ],
              ),
            ),

            const SizedBox(height: EGoSpacing.xl),

            Text(
              'Frequently Asked Questions',
              style: EGoTypography.titleSmall.copyWith(
                color: EGoColors.grey800,
              ),
            ),
            const SizedBox(height: EGoSpacing.sm),

            // FAQs accordion list
            ...MockData.faqs.map((faq) => _FaqExpansionTile(faq: faq)),

            const SizedBox(height: EGoSpacing.xl),

            // Contact simulation card
            Container(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              decoration: BoxDecoration(
                color: EGoColors.surface,
                borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
                border: Border.all(color: EGoColors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Emergency & Safety', style: EGoTypography.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Your safety is our highest priority during every ride.',
                    style: EGoTypography.bodySmall.copyWith(
                      color: EGoColors.grey600,
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Emergency alert triggered (Simulated in demo)',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shield_outlined,
                      color: EGoColors.error,
                    ),
                    label: const Text(
                      'Emergency SOS (Mock)',
                      style: TextStyle(color: EGoColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqExpansionTile extends StatelessWidget {
  const _FaqExpansionTile({required this.faq});
  final FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: EGoSpacing.sm),
      decoration: BoxDecoration(
        color: EGoColors.surface,
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        border: Border.all(color: EGoColors.outlineVariant),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: EGoTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: EGoColors.onSurface,
          ),
        ),
        iconColor: EGoColors.brandPrimary,
        collapsedIconColor: EGoColors.grey500,
        tilePadding: const EdgeInsets.symmetric(horizontal: EGoSpacing.lg),
        childrenPadding: const EdgeInsets.fromLTRB(
          EGoSpacing.lg,
          0,
          EGoSpacing.lg,
          EGoSpacing.lg,
        ),
        shape: const Border(),
        children: [
          Text(
            faq.answer,
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
