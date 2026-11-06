import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO ride rating screen.
class RideRatingScreen extends StatefulWidget {
  const RideRatingScreen({super.key});

  @override
  State<RideRatingScreen> createState() => _RideRatingScreenState();
}

class _RideRatingScreenState extends State<RideRatingScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _submitted = false;

  static const _quickTags = [
    'Great driver',
    'Very clean',
    'On time',
    'Smooth ride',
    'Friendly',
    'Safe driving',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final comment = [
      ..._selectedTags,
      if (_commentController.text.trim().isNotEmpty)
        _commentController.text.trim(),
    ].join(', ');

    await context.read<AppState>().submitRating(
      rating: _rating,
      comment: comment.isEmpty ? null : comment,
    );
    setState(() => _submitted = true);

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, EGoRouter.home, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final driver = context.read<AppState>().assignedDriver;

    if (_submitted) {
      return Scaffold(
        backgroundColor: EGoColors.surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite,
                size: 72,
                color: EGoColors.brandPrimary,
              ),
              const SizedBox(height: EGoSpacing.xl),
              Text('Thank you!', style: EGoTypography.headlineSmall),
              const SizedBox(height: EGoSpacing.sm),
              Text(
                'Your feedback helps us improve.',
                style: EGoTypography.bodyMedium.copyWith(
                  color: EGoColors.grey500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(
        title: const Text('Rate your ride'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppState>().skipRating();
              Navigator.pushNamedAndRemoveUntil(
                context,
                EGoRouter.home,
                (_) => false,
              );
            },
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(EGoSpacing.xxl),
        child: Column(
          children: [
            // Driver avatar
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: EGoColors.brandPrimaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 48,
                color: EGoColors.brandPrimary,
              ),
            ),
            const SizedBox(height: EGoSpacing.md),
            Text(
              driver?.name ?? 'Your driver',
              style: EGoTypography.titleLarge,
            ),
            const SizedBox(height: EGoSpacing.xxxl),
            Text('How was your ride?', style: EGoTypography.headlineSmall),
            const SizedBox(height: EGoSpacing.xl),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      size: 44,
                      color: i < _rating
                          ? const Color(0xFFFBBC04)
                          : EGoColors.grey300,
                    ),
                  ),
                ),
              ),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: EGoSpacing.sm),
              Text(
                _ratingLabel(_rating),
                style: EGoTypography.titleSmall.copyWith(
                  color: EGoColors.brandPrimary,
                ),
              ),
            ],
            const SizedBox(height: EGoSpacing.xxxl),
            // Quick tags
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What went well?',
                style: EGoTypography.titleSmall.copyWith(
                  color: EGoColors.grey700,
                ),
              ),
            ),
            const SizedBox(height: EGoSpacing.md),
            Wrap(
              spacing: EGoSpacing.sm,
              runSpacing: EGoSpacing.sm,
              children: _quickTags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor: EGoColors.brandPrimaryLight,
                  checkmarkColor: EGoColors.brandPrimary,
                  labelStyle: EGoTypography.labelMedium.copyWith(
                    color: selected
                        ? EGoColors.brandPrimary
                        : EGoColors.grey700,
                  ),
                  side: BorderSide(
                    color: selected
                        ? EGoColors.brandPrimary
                        : EGoColors.outline,
                  ),
                  backgroundColor: EGoColors.surface,
                );
              }).toList(),
            ),
            const SizedBox(height: EGoSpacing.xl),
            // Comment
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a comment (optional)',
                hintStyle: EGoTypography.bodyMedium.copyWith(
                  color: EGoColors.grey400,
                ),
                filled: true,
                fillColor: EGoColors.grey100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
                  borderSide: const BorderSide(
                    color: EGoColors.brandPrimary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(EGoSpacing.lg),
              ),
            ),
            const SizedBox(height: EGoSpacing.xxxl),
            EGoPrimaryButton(
              onPressed: _submit,
              label: 'Submit rating',
              icon: const Icon(Icons.send, color: EGoColors.brandBlack),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1:
        return 'Very poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }
}
