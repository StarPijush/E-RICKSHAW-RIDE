import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';
import 'package:e_go/features/auth/data/customer_repository.dart';

/// E-GO OTP verification screen.
/// Development mock: OTP is always 123456.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _isInvalidOtp = false;
  int _resendCountdown = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 30;
      _canResend = false;
    });
    _countdown();
  }

  Future<void> _countdown() async {
    for (var i = 30; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _resendCountdown = i;
        if (i == 0) _canResend = true;
      });
    }
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    setState(() => _isInvalidOtp = false);

    if (value.length > 1) {
      // Handle paste
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < 6 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final nextFocus = (digits.length < 6) ? digits.length : 5;
      _focusNodes[nextFocus].requestFocus();
      if (digits.length == 6) _verify();
      return;
    }

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_otpValue.length == 6) _verify();
  }

  void _onKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verify() async {
    final otp = _otpValue;
    if (otp.length != 6) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final valid = context.read<AppState>().validateOtp(otp);
    if (valid) {
      Navigator.pushReplacementNamed(context, EGoRouter.profileSetup);
    } else {
      setState(() {
        _isLoading = false;
        _isInvalidOtp = true;
      });
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(
        backgroundColor: EGoColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const EgoLogo.wordmark(height: 22),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: EGoSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: EGoSpacing.xl),
              Text('Verify your\nnumber', style: EGoTypography.headlineMedium),
              const SizedBox(height: EGoSpacing.sm),
              Text(
                'Enter the 6-digit code sent to\n+91 ${widget.phone}',
                style: EGoTypography.bodyMedium.copyWith(
                  color: EGoColors.grey500,
                ),
              ),
              // Dev hint
              const SizedBox(height: EGoSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: EGoSpacing.md,
                  vertical: EGoSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: EGoColors.warningLight,
                  borderRadius: BorderRadius.circular(EGoSpacing.radiusMedium),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: EGoColors.warning,
                    ),
                    const SizedBox(width: EGoSpacing.xs),
                    Text(
                      'Demo OTP: ${MockCustomerRepository.devMockOtp}',
                      style: EGoTypography.labelSmall.copyWith(
                        color: EGoColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EGoSpacing.xxxl),
              // OTP fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _buildDigitField(i)),
              ),
              if (_isInvalidOtp) ...[
                const SizedBox(height: EGoSpacing.md),
                Text(
                  'Invalid OTP. Please try again.',
                  style: EGoTypography.bodySmall.copyWith(
                    color: EGoColors.error,
                  ),
                ),
              ],
              const SizedBox(height: EGoSpacing.xxxl),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      EGoColors.brandPrimary,
                    ),
                  ),
                )
              else ...[
                EGoPrimaryButton(
                  onPressed: _otpValue.length == 6 ? _verify : null,
                  label: 'Verify',
                ),
                const SizedBox(height: EGoSpacing.xl),
                Center(
                  child: _canResend
                      ? TextButton(
                          onPressed: _startResendCountdown,
                          child: Text(
                            'Resend OTP',
                            style: EGoTypography.labelLarge.copyWith(
                              color: EGoColors.brandPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Resend OTP in ${_resendCountdown}s',
                          style: EGoTypography.bodyMedium.copyWith(
                            color: EGoColors.grey500,
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDigitField(int index) {
    return SizedBox(
      width: 46,
      height: 56,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) => _onKeyPress(index, event),
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6, // Allow paste
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: EGoTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          onChanged: (v) => _onDigitChanged(index, v),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: _isInvalidOtp
                ? EGoColors.errorLight
                : _focusNodes[index].hasFocus
                ? EGoColors.brandPrimaryLight
                : EGoColors.grey100,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
              borderSide: const BorderSide(color: EGoColors.error),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
