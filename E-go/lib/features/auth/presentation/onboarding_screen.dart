import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO onboarding flow.
/// 3 slides introducing toto + bike rides in Jhargram with official brand identity.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _OnboardingSlide(
      useBrandMark: true,
      iconColor: EGoColors.brandBlack,
      circleBgColor: EGoColors.brandYellowLight,
      title: 'Ride across\nJhargram',
      subtitle:
          'Book affordable Toto (E-Rickshaw) and Bike rides anywhere in Jhargram city.',
    ),
    _OnboardingSlide(
      icon: Icons.two_wheeler_rounded,
      iconColor: EGoColors.brandBlack,
      circleBgColor: EGoColors.brandYellowLight,
      title: 'Fast bike rides,\nanytime',
      subtitle:
          'Need to get somewhere quickly? A bike rider is just a tap away.',
    ),
    _OnboardingSlide(
      icon: Icons.location_on_rounded,
      iconColor: EGoColors.brandBlack,
      circleBgColor: EGoColors.brandYellowLight,
      title: 'Move your way,\nevery day',
      subtitle:
          'Set your pickup, choose a vehicle, and ride — it\'s that simple.',
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() async {
    await context.read<AppState>().markOnboardingComplete();
    if (mounted) {
      Navigator.pushReplacementNamed(context, EGoRouter.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _slides.length - 1;
    return Scaffold(
      backgroundColor: EGoColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: EGoSpacing.lg,
                  vertical: EGoSpacing.sm,
                ),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip',
                    style: EGoTypography.labelLarge.copyWith(
                      color: EGoColors.grey500,
                    ),
                  ),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingPage(slide: _slides[i]),
              ),
            ),
            // Dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                EGoSpacing.xxl,
                EGoSpacing.xl,
                EGoSpacing.xxl,
                EGoSpacing.xxxl,
              ),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? EGoColors.brandPrimary
                              : EGoColors.grey300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.xxl),
                  EGoPrimaryButton(
                    onPressed: _next,
                    label: isLast ? 'Get started' : 'Next',
                    icon: isLast
                        ? const Icon(
                            Icons.arrow_forward_rounded,
                            color: EGoColors.brandBlack,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    this.icon,
    this.useBrandMark = false,
    required this.iconColor,
    required this.circleBgColor,
    required this.title,
    required this.subtitle,
  });
  final IconData? icon;
  final bool useBrandMark;
  final Color iconColor;
  final Color circleBgColor;
  final String title;
  final String subtitle;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.slide});
  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EGoSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration area with official brand mark
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: slide.circleBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: slide.useBrandMark
                  ? const EgoLogo.icon(height: 80)
                  : (slide.icon != null
                        ? Icon(slide.icon, size: 84, color: slide.iconColor)
                        : const SizedBox.shrink()),
            ),
          ),
          const SizedBox(height: EGoSpacing.xxxl),
          Text(
            slide.title,
            style: EGoTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: EGoColors.brandBlack,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: EGoSpacing.lg),
          Text(
            slide.subtitle,
            style: EGoTypography.bodyLarge.copyWith(
              color: EGoColors.grey600,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
