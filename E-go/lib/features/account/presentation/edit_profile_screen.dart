import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO edit profile screen.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().profile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await context.read<AppState>().updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(EGoSpacing.xxl),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: EGoColors.brandYellowLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: EGoColors.brandBlack,
                ),
              ),
              const SizedBox(height: EGoSpacing.xxxl),
              _FieldLabel('Full name *'),
              const SizedBox(height: EGoSpacing.sm),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: EGoTypography.bodyLarge,
                decoration: _dec('Enter your full name'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  if (v.trim().length < 2) return 'Name too short';
                  return null;
                },
              ),
              const SizedBox(height: EGoSpacing.xl),
              _FieldLabel('Email (optional)'),
              const SizedBox(height: EGoSpacing.sm),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: EGoTypography.bodyLarge,
                decoration: _dec('Enter your email'),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty) {
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) {
                      return 'Enter a valid email';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: EGoSpacing.xxxl),
              EGoPrimaryButton(
                onPressed: _isLoading ? null : _save,
                label: 'Save changes',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: EGoTypography.labelMedium.copyWith(color: EGoColors.grey700),
      ),
    );
  }
}
