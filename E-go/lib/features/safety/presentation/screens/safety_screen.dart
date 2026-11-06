import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/mock_data/mock_data.dart';
import 'package:e_go/shared/widgets/bottom_nav_bar.dart';

/// E-GO Safety & Support screen.
/// Dedicated screen for passenger safety, emergency assistance, and local support in Jhargram.
class SafetyScreen extends StatelessWidget {
  const SafetyScreen({
    super.key,
    this.showBottomNav = false,
    this.onBottomNavTap,
  });

  final bool showBottomNav;
  final ValueChanged<int>? onBottomNavTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency SOS Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: EGoColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: EGoColors.error.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: EGoColors.error,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency SOS',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF131E1A),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Instant alert to contacts & Jhargram Police',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12,
                                  color: Color(0xFF65716B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Emergency SOS triggered (Demo Simulation). Contacts notified.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: EGoColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.warning_amber_rounded, size: 20),
                        label: const Text(
                          'TRIGGER EMERGENCY SOS',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Safety Features Section
              const Text(
                'Ride Safety Guidelines',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF131E1A),
                ),
              ),
              const SizedBox(height: 12),

              _buildSafetyCard(
                icon: Icons.verified_user_outlined,
                title: 'Verified TOTO Drivers',
                description:
                    'Every E-GO driver in Jhargram is registered and police-verified with visible registration badges.',
              ),
              const SizedBox(height: 10),
              _buildSafetyCard(
                icon: Icons.share_location_outlined,
                title: 'Share Live Ride Status',
                description:
                    'Share your live route and estimated arrival time with friends and family with a single tap.',
              ),
              const SizedBox(height: 10),
              _buildSafetyCard(
                icon: Icons.support_agent_outlined,
                title: '24/7 Local Assistance',
                description:
                    'Our local Jhargram transit desk is always reachable for lost items, fare inquiries, and route questions.',
              ),

              const SizedBox(height: 24),

              // Frequently Asked Questions
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF131E1A),
                ),
              ),
              const SizedBox(height: 12),

              ...MockData.faqs.map(
                (faq) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE3E8E3)),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF131E1A),
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Text(
                        faq.answer,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          color: Color(0xFF3F4943),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? EGoBottomNavBar(
              selectedIndex: 2,
              onTap: onBottomNavTap,
              profileLabel: 'Profile',
            )
          : null,
    );
  }

  Widget _buildSafetyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E8E3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF176B4F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF176B4F), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF131E1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: Color(0xFF65716B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
