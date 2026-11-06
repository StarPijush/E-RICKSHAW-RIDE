import 'package:flutter/material.dart';
import 'package:e_go/app/theme/colors.dart';

/// Clean minimal header for E-GO Rides screen.
/// Displays "Your rides" title and a circular 40x40 history action button.
class RidesHeader extends StatelessWidget {
  const RidesHeader({super.key, this.onHistoryTap});

  final VoidCallback? onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              'Your rides',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: EGoColors.onSurfaceText,
                letterSpacing: -0.42,
                height: 1.28,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onHistoryTap,
              customBorder: const CircleBorder(),
              splashColor: EGoColors.surfaceContainer,
              highlightColor: EGoColors.surfaceContainerLow,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.history,
                  size: 22,
                  color: EGoColors.onSurfaceVariantText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
