import 'package:flutter/material.dart';
import 'package:e_go/app/theme/colors.dart';

/// Primary booking CTA button for E-GO Rides screen.
/// Pill-shaped with plus icon and "Book a TOTO" label.
class BookTotoButton extends StatelessWidget {
  const BookTotoButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, minHeight: 52),
      decoration: BoxDecoration(
        color: EGoColors.brandYellow,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(9999),
          splashColor: Colors.black.withValues(alpha: 0.1),
          highlightColor: Colors.black.withValues(alpha: 0.05),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 20, color: EGoColors.brandBlack),
                SizedBox(width: 8),
                Text(
                  'Book a TOTO',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: EGoColors.brandBlack,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
