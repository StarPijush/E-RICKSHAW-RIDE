import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO profile screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AppState>().profile;

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, EGoRouter.editProfile),
            tooltip: 'Edit profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              color: EGoColors.surface,
              padding: const EdgeInsets.all(EGoSpacing.xxl),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: EGoColors.brandYellowLight,
                      shape: BoxShape.circle,
                    ),
                    child: profile.name.isNotEmpty
                        ? Center(
                            child: Text(
                              profile.name[0].toUpperCase(),
                              style: EGoTypography.headlineLarge.copyWith(
                                color: EGoColors.brandBlack,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 44,
                            color: EGoColors.brandBlack,
                          ),
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  Text(
                    profile.name.isNotEmpty ? profile.name : 'Set up profile',
                    style: EGoTypography.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.phone.isNotEmpty ? profile.phone : '—',
                    style: EGoTypography.bodyMedium.copyWith(
                      color: EGoColors.grey500,
                    ),
                  ),
                  if (profile.email != null && profile.email!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      profile.email!,
                      style: EGoTypography.bodySmall.copyWith(
                        color: EGoColors.grey500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: EGoSpacing.lg),
            // Menu sections
            _MenuSection(
              title: 'Rides',
              items: [
                _MenuItem(
                  icon: Icons.history,
                  label: 'My rides',
                  onTap: () => Navigator.pushNamed(context, EGoRouter.myRides),
                ),
                _MenuItem(
                  icon: Icons.bookmark_border,
                  label: 'Saved places',
                  onTap: () =>
                      Navigator.pushNamed(context, EGoRouter.savedPlaces),
                ),
              ],
            ),
            const SizedBox(height: EGoSpacing.md),
            _MenuSection(
              title: 'Payments',
              items: [
                _MenuItem(
                  icon: Icons.payments_outlined,
                  label: 'Payment methods',
                  onTap: () =>
                      Navigator.pushNamed(context, EGoRouter.paymentMethods),
                ),
              ],
            ),
            const SizedBox(height: EGoSpacing.md),
            _MenuSection(
              title: 'Help',
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  onTap: () =>
                      Navigator.pushNamed(context, EGoRouter.helpSupport),
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () =>
                      Navigator.pushNamed(context, EGoRouter.notifications),
                ),
              ],
            ),
            const SizedBox(height: EGoSpacing.md),
            _MenuSection(
              title: 'App',
              items: [
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => Navigator.pushNamed(context, EGoRouter.settings),
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: 'About E-GO',
                  onTap: () => Navigator.pushNamed(context, EGoRouter.about),
                ),
              ],
            ),
            const SizedBox(height: EGoSpacing.xl),
            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: EGoSpacing.lg),
              child: EGoSecondaryButton(
                onPressed: () => _showLogoutDialog(context),
                label: 'Log out',
                icon: const Icon(Icons.logout, color: EGoColors.brandBlack),
              ),
            ),
            const SizedBox(height: EGoSpacing.xxl),
            const Center(
              child: EgoLogo.wordmark(height: 18, color: EGoColors.grey400),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Move your way · Jhargram',
                style: EGoTypography.labelSmall.copyWith(
                  color: EGoColors.grey400,
                ),
              ),
            ),
            const SizedBox(height: EGoSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AppState>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  EGoRouter.splash,
                  (_) => false,
                );
              }
            },
            child: Text('Log out', style: TextStyle(color: EGoColors.error)),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: EGoSpacing.lg,
            vertical: EGoSpacing.sm,
          ),
          child: Text(
            title,
            style: EGoTypography.labelMedium.copyWith(
              color: EGoColors.grey500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          color: EGoColors.surface,
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: EGoColors.grey100,
                        borderRadius: BorderRadius.circular(
                          EGoSpacing.radiusMedium,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: EGoColors.grey700,
                      ),
                    ),
                    title: Text(item.label, style: EGoTypography.bodyMedium),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: EGoColors.grey400,
                    ),
                    onTap: item.onTap,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: EGoSpacing.lg,
                      vertical: 2,
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 68, endIndent: 0),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}
