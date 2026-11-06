import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';

/// E-GO splash screen.
/// Displays official brand identity, then routes to onboarding or home based on auth state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for animations and app state init
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final appState = context.read<AppState>();
    // Wait until auth is initialized
    while (!appState.isAuthInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    if (!mounted) return;

    if (appState.isLoggedIn) {
      Navigator.pushReplacementNamed(context, EGoRouter.home);
    } else if (appState.hasCompletedOnboarding) {
      Navigator.pushReplacementNamed(context, EGoRouter.login);
    } else {
      Navigator.pushReplacementNamed(context, EGoRouter.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.brandYellow,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Official Primary Logo
                Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: const EgoLogo(
                      variant: EgoLogoVariant.primary,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: EGoSpacing.lg),
                // Brand Tagline
                Opacity(
                  opacity: _taglineOpacity.value,
                  child: Text(
                    'Move your way.',
                    style: EGoTypography.brandTagline.copyWith(
                      color: EGoColors.brandBlack.withValues(alpha: 0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
