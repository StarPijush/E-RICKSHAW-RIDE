import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO login screen — phone number entry.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final phone = _phoneController.text.trim();
    await context.read<AppState>().submitPhone(phone);
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, EGoRouter.otp, arguments: phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: EGoColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: EGoSpacing.xxl,
            right: EGoSpacing.xxl,
            top: EGoSpacing.xxl,
            bottom: bottom + EGoSpacing.xxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Official E-GO Primary Logo
                const EgoLogo(variant: EgoLogoVariant.primary, height: 64),
                const SizedBox(height: EGoSpacing.xxl),
                Text(
                  'Enter your\nphone number',
                  style: EGoTypography.headlineMedium.copyWith(
                    color: EGoColors.brandBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: EGoSpacing.sm),
                Text(
                  'We\'ll send you a verification code',
                  style: EGoTypography.bodyMedium.copyWith(
                    color: EGoColors.grey500,
                  ),
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                // Phone input
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: EGoTypography.titleMedium.copyWith(
                    color: EGoColors.brandBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: '9876543210',
                    hintStyle: EGoTypography.titleMedium.copyWith(
                      color: EGoColors.grey400,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: EGoSpacing.lg,
                        vertical: EGoSpacing.md,
                      ),
                      child: Text(
                        '+91',
                        style: EGoTypography.titleMedium.copyWith(
                          color: EGoColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0),
                    filled: true,
                    fillColor: EGoColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                      borderSide: const BorderSide(
                        color: EGoColors.brandBlack,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                      borderSide: const BorderSide(
                        color: EGoColors.error,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                      borderSide: const BorderSide(
                        color: EGoColors.error,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (val.trim().length != 10) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                // Submit button
                EGoPrimaryButton(
                  onPressed: _submit,
                  label: 'Continue',
                  isLoading: _isLoading,
                ),
                const SizedBox(height: EGoSpacing.xxl),
                // Terms
                Center(
                  child: Text(
                    'By continuing you agree to the Terms of Service\nand Privacy Policy of E-GO.',
                    textAlign: TextAlign.center,
                    style: EGoTypography.bodySmall.copyWith(
                      color: EGoColors.grey400,
                      height: 1.5,
                    ),
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
