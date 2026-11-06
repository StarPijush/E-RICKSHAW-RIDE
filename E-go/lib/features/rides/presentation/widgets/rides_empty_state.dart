import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'book_toto_button.dart';

/// Minimalist empty state for E-GO Rides screen.
/// Shows official isolated TOTO brand mark, clean typography, and the primary "Book a TOTO" CTA.
class RidesEmptyState extends StatelessWidget {
  const RidesEmptyState({super.key, required this.onBookPressed});

  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Official brand mark in subtle badge
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: EGoColors.brandYellowLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: EGoColors.brandYellow.withValues(
                                alpha: 0.5,
                              ),
                              width: 1.5,
                            ),
                          ),
                          child: const Center(child: EgoLogo.icon(height: 38)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No rides yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: EGoColors.brandBlack,
                            letterSpacing: -0.2,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 260),
                          child: const Text(
                            'Your completed and cancelled rides will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: EGoColors.grey500,
                              height: 1.45,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        BookTotoButton(onPressed: onBookPressed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
