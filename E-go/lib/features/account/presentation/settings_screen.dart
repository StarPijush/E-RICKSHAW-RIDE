import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';

/// E-GO settings screen.
/// Manage app preferences, language, notifications, and privacy.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  bool _pushNotifications = true;
  bool _smsUpdates = true;
  bool _promotionalOffers = false;

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EGoSpacing.radiusXLarge),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: EGoSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Language', style: EGoTypography.titleMedium),
              const SizedBox(height: EGoSpacing.md),
              ListTile(
                title: const Text('English'),
                trailing: _selectedLanguage == 'English'
                    ? const Icon(Icons.check, color: EGoColors.brandPrimary)
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = 'English');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('বাংলা (Bengali)'),
                trailing: _selectedLanguage == 'বাংলা (Bengali)'
                    ? const Icon(Icons.check, color: EGoColors.brandPrimary)
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = 'বাংলা (Bengali)');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(EGoSpacing.lg),
        children: [
          // Language section
          _SettingsSection(
            title: 'Preferences',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: EGoColors.brandPrimary,
                ),
                title: const Text('App Language'),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: EGoColors.grey400,
                ),
                onTap: _showLanguageSelector,
              ),
            ],
          ),

          const SizedBox(height: EGoSpacing.lg),

          // Notifications
          _SettingsSection(
            title: 'Notifications',
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text('Ride Status Alerts'),
                subtitle: const Text(
                  'Notifications when driver arrives or begins trip',
                ),
                value: _pushNotifications,
                activeThumbColor: EGoColors.brandPrimary,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile(
                secondary: const Icon(Icons.sms_outlined),
                title: const Text('SMS Updates'),
                subtitle: const Text(
                  'Receive important ride notifications via SMS',
                ),
                value: _smsUpdates,
                activeThumbColor: EGoColors.brandPrimary,
                onChanged: (val) => setState(() => _smsUpdates = val),
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile(
                secondary: const Icon(Icons.discount_outlined),
                title: const Text('Offers & Discounts'),
                subtitle: const Text(
                  'Special discounts and coupons for Jhargram rides',
                ),
                value: _promotionalOffers,
                activeThumbColor: EGoColors.brandPrimary,
                onChanged: (val) => setState(() => _promotionalOffers = val),
              ),
            ],
          ),

          const SizedBox(height: EGoSpacing.lg),

          // Privacy & Legal
          _SettingsSection(
            title: 'Privacy & Legal',
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: EGoColors.grey400,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-GO Privacy Policy (Demo)'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Service'),
                trailing: const Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: EGoColors.grey400,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-GO Terms of Service (Demo)'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: EGoSpacing.xl),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: EGoSpacing.md),
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Log out?'),
                    content: const Text(
                      'Are you sure you want to log out of E-GO?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(color: EGoColors.error),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await context.read<AppState>().logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      EGoRouter.splash,
                      (_) => false,
                    );
                  }
                }
              },
              icon: const Icon(Icons.logout, color: EGoColors.error),
              label: const Text(
                'Log out',
                style: TextStyle(color: EGoColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: EGoColors.error),
                padding: const EdgeInsets.symmetric(vertical: EGoSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: EGoSpacing.sm,
            vertical: EGoSpacing.xs,
          ),
          child: Text(
            title,
            style: EGoTypography.labelMedium.copyWith(color: EGoColors.grey500),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: EGoColors.surface,
            borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
            border: Border.all(color: EGoColors.outlineVariant),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
