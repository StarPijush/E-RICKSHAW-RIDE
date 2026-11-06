import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO profile setup screen.
/// Collects customer name and optional email after OTP verification.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await context.read<AppState>().completeProfileSetup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
    );
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, EGoRouter.home, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(
        backgroundColor: EGoColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const EgoLogo.wordmark(height: 22),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: EGoSpacing.xxl,
            right: EGoSpacing.xxl,
            bottom: bottom + EGoSpacing.xxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: EGoSpacing.lg),
                // Avatar placeholder
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: EGoColors.brandYellowLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: EGoColors.brandYellow,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: EGoColors.brandBlack,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: EGoColors.brandYellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: EGoColors.brandBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                Text('Set up your profile', style: EGoTypography.headlineSmall),
                const SizedBox(height: EGoSpacing.sm),
                Text(
                  'Tell us your name so drivers can find you',
                  style: EGoTypography.bodyMedium.copyWith(
                    color: EGoColors.grey500,
                  ),
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                // Name
                Text(
                  'Full name *',
                  style: EGoTypography.labelMedium.copyWith(
                    color: EGoColors.grey700,
                  ),
                ),
                const SizedBox(height: EGoSpacing.sm),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: EGoTypography.bodyLarge,
                  decoration: _inputDecoration('Enter your full name'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (v.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: EGoSpacing.xl),
                // Email
                Text(
                  'Email (optional)',
                  style: EGoTypography.labelMedium.copyWith(
                    color: EGoColors.grey700,
                  ),
                ),
                const SizedBox(height: EGoSpacing.sm),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: EGoTypography.bodyLarge,
                  decoration: _inputDecoration('Enter your email'),
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty) {
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                EGoPrimaryButton(
                  onPressed: _isLoading ? null : _submit,
                  label: 'Start riding',
                  isLoading: _isLoading,
                  icon: const Icon(Icons.arrow_forward, color: EGoColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: EGoTypography.bodyLarge.copyWith(color: EGoColors.grey400),
      filled: true,
      fillColor: EGoColors.grey100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.brandBlack, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: EGoSpacing.lg,
        vertical: EGoSpacing.lg,
      ),
    );
  }
}
