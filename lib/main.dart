import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const EzFinanzApp());
}

const Color brandGreen = Color(0xFF1EC677);
const Color primaryBlue = Color(0xFF0B53A0);
const Color primaryText = Color(0xFF1E1E1E);
const Color titleBlack = primaryText;
const Color bodyGrey = primaryText;
const Color taglineGrey = Color(0xFF1E1E1E);
const Color dotInactive = Color(0xFF0B53A0);
const Color bgWhite = Color(0xFFFFFFFF);

class EzFinanzApp extends StatelessWidget {
  const EzFinanzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EzFinanz',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bgWhite,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          surface: bgWhite,
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String highlight;
  final String description;

  const OnboardingData({
    required this.image,
    required this.title,
    required this.highlight,
    required this.description,
  });
}

const List<OnboardingData> onboardingPages = [
  OnboardingData(
    image: 'assets/onboarding_apply.png',
    title: 'Apply for a loan',
    highlight: 'in minutes',
    description:
        'Complete your application quickly with a simple and smooth process.',
  ),
  OnboardingData(
    image: 'assets/onboarding_track.png',
    title: 'Track all your',
    highlight: 'payments',
    description:
        'Stay updated with your loan status, payments and upcoming dues.',
  ),
  OnboardingData(
    image: 'assets/onboarding_secure.png',
    title: 'Safe and',
    highlight: 'secure',
    description:
        'Your personal and financial information is protected at every step.',
  ),
];

class ScreenMetrics {
  final double width;
  final double height;
  final double scale;
  final double horizontal;
  final double titleSize;
  final double bodySize;
  final double skipSize;
  final double buttonHeight;
  final double buttonText;
  final double bottomGap;
  final double illustrationMax;

  ScreenMetrics(Size size)
    : width = size.width,
      height = size.height,
      scale = (size.height / 812).clamp(0.82, 1.06),
      horizontal = (size.width * 0.072).clamp(22.0, 32.0),
      titleSize = (size.height * 0.0345).clamp(26.0, 32.0),
      bodySize = (size.height * 0.0185).clamp(14.0, 16.0),
      skipSize = (size.height * 0.0205).clamp(15.5, 17.0),
      buttonHeight = (size.height * 0.064).clamp(50.0, 54.0),
      buttonText = (size.height * 0.0215).clamp(16.5, 18.0),
      bottomGap = (size.height * 0.018).clamp(12.0, 20.0),
      illustrationMax = (size.height * 0.42).clamp(240.0, 360.0);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPageTransitioning = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToWelcome() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  Future<void> _previousPage() async {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    if (_isPageTransitioning || _currentPage == 0) {
      return;
    }

    setState(() => _isPageTransitioning = true);
    await _pageController.previousPage(
      duration: Duration(milliseconds: isReducedMotion ? 1 : 400),
      curve: isReducedMotion ? Curves.linear : Curves.easeInOutCubic,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isPageTransitioning = false);
  }

  Future<void> _nextPage() async {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    if (_isPageTransitioning) {
      return;
    }

    if (_currentPage == onboardingPages.length - 1) {
      _goToWelcome();
      return;
    }

    setState(() => _isPageTransitioning = true);
    await _pageController.nextPage(
      duration: Duration(milliseconds: isReducedMotion ? 1 : 400),
      curve: isReducedMotion ? Curves.linear : Curves.easeInOutCubic,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isPageTransitioning = false);
  }

  @override
  Widget build(BuildContext context) {
    final isLastSlide = _currentPage == onboardingPages.length - 1;
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (_currentPage > 0) {
          _previousPage();
        }
      },
      child: Scaffold(
        backgroundColor: bgWhite,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final m = ScreenMetrics(constraints.biggest);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: m.horizontal),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.015),
                    AppHeader(
                      showBack: _currentPage > 0,
                      onBack: _isPageTransitioning ? null : _previousPage,
                      showSkip: true,
                      skipTextSize: m.skipSize,
                      onSkip: _goToWelcome,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: onboardingPages.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          if (!mounted) {
                            return;
                          }
                          setState(() {
                            _currentPage = index;
                            _isPageTransitioning = false;
                          });
                        },
                        itemBuilder: (context, index) {
                          return OnboardingSlide(
                            key: ValueKey('onboarding-$index'),
                            data: onboardingPages[index],
                            metrics: m,
                            isActive: index == _currentPage,
                            reducedMotion: isReducedMotion,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    PageDots(
                      count: onboardingPages.length,
                      activeIndex: _currentPage,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: SizedBox(
                          width: double.infinity,
                          height: m.buttonHeight,
                          child: PillButton(
                            label: isLastSlide ? 'Get started' : 'Next',
                            showArrow: true,
                            height: m.buttonHeight,
                            fontSize: m.buttonText,
                            onPressed: _isPageTransitioning ? null : _nextPage,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: m.bottomGap),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatefulWidget {
  const OnboardingSlide({
    super.key,
    required this.data,
    required this.metrics,
    required this.isActive,
    required this.reducedMotion,
  });

  final OnboardingData data;
  final ScreenMetrics metrics;
  final bool isActive;
  final bool reducedMotion;

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide>
    with TickerProviderStateMixin {
  late final AnimationController _illustrationController;
  late final AnimationController _headingController;
  late final AnimationController _descriptionController;
  Timer? _headingDelay;
  Timer? _descriptionDelay;

  @override
  void initState() {
    super.initState();
    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _headingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _descriptionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _syncAnimations();
  }

  @override
  void didUpdateWidget(covariant OnboardingSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      _syncAnimations();
    }
  }

  void _syncAnimations() {
    _headingDelay?.cancel();
    _descriptionDelay?.cancel();

    if (widget.reducedMotion) {
      _illustrationController.value = 1.0;
      _headingController.value = 1.0;
      _descriptionController.value = 1.0;
      return;
    }

    if (!widget.isActive) {
      _illustrationController.value = 0.0;
      _headingController.value = 0.0;
      _descriptionController.value = 0.0;
      return;
    }

    _illustrationController.forward(from: 0.0);
    _headingDelay = Timer(const Duration(milliseconds: 120), () {
      if (mounted) {
        _headingController.forward(from: 0.0);
      }
    });
    _descriptionDelay = Timer(const Duration(milliseconds: 320), () {
      if (mounted) {
        _descriptionController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _headingDelay?.cancel();
    _descriptionDelay?.cancel();
    _illustrationController.dispose();
    _headingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadeIllustration = CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.easeOutCubic,
    );
    final fadeHeading = CurvedAnimation(
      parent: _headingController,
      curve: Curves.easeOut,
    );
    final fadeDescription = CurvedAnimation(
      parent: _descriptionController,
      curve: Curves.easeOut,
    );
    final slideIllustration =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic))
            .animate(_illustrationController);
    final slideHeading = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_headingController);
    final slideDescription = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_descriptionController);

    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationHeight = (constraints.maxHeight * 0.44).clamp(
          220.0,
          340.0,
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.metrics.horizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: illustrationHeight,
                child: FadeTransition(
                  opacity: fadeIllustration,
                  child: SlideTransition(
                    position: slideIllustration,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        widget.data.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 290),
                  child: FadeTransition(
                    opacity: fadeHeading,
                    child: SlideTransition(
                      position: slideHeading,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: widget.data.title,
                              style: const TextStyle(
                                color: titleBlack,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                height: 1.22,
                                letterSpacing: -0.6,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.data.highlight}',
                              style: const TextStyle(
                                color: primaryBlue,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                height: 1.22,
                                letterSpacing: -0.6,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 290),
                  child: FadeTransition(
                    opacity: fadeDescription,
                    child: SlideTransition(
                      position: slideDescription,
                      child: Text(
                        widget.data.description,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 15,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  bool _animationStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animationStarted) {
      if (MediaQuery.of(context).disableAnimations) {
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }
      _animationStarted = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = ScreenMetrics(MediaQuery.of(context).size);
    final logoHeight = (m.height * 0.048).clamp(36.0, 44.0);
    final taglineSize = (m.height * 0.024).clamp(18.0, 21.0);
    final welcomeSize = (m.height * 0.031).clamp(24.0, 28.0);

    final logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.24, curve: Curves.easeOut),
    );
    final taglineOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.38, curve: Curves.easeOut),
    );
    final heroOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.22, 0.7, curve: Curves.easeOutCubic),
    );
    final heroSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
            .chain(
              CurveTween(
                curve: const Interval(0.18, 0.7, curve: Curves.easeOutCubic),
              ),
            )
            .animate(_controller);
    final headingOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.82, curve: Curves.easeOut),
    );
    final textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.88, curve: Curves.easeOut),
    );
    final buttonOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 0.98, curve: Curves.easeOut),
    );

    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight = (constraints.maxHeight * 0.40).clamp(
              230.0,
              320.0,
            );

            return Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: m.horizontal),
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: logoOpacity,
                        child: EzFinanzLogo(height: logoHeight),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: taglineOpacity,
                        child: Text(
                          'Your Financial Journey\nMade Simple',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: taglineGrey,
                            fontSize: taglineSize,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            letterSpacing: -0.2,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FadeTransition(
                      opacity: heroOpacity,
                      child: SlideTransition(
                        position: heroSlide,
                        child: ClipPath(
                          clipper: const WelcomeHeroClipper(),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.white,
                                ],
                                stops: [0.0, 0.18, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: SizedBox(
                              width: double.infinity,
                              height: heroHeight,
                              child: Image.asset(
                                'assets/welcome_hero.png',
                                width: double.infinity,
                                height: heroHeight,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: m.horizontal),
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: headingOpacity,
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome to ',
                                  style: TextStyle(
                                    color: titleBlack,
                                    fontSize: welcomeSize,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.4,
                                    height: 1.15,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: 'Ezfinanz',
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontSize: welcomeSize,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.4,
                                    height: 1.15,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: textOpacity,
                        child: const Center(
                          child: Text(
                            'Apply. Track. Grow. All in one place.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.032),
                      FadeTransition(
                        opacity: buttonOpacity,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: SizedBox(
                              width: double.infinity,
                              height: m.buttonHeight,
                              child: PillButton(
                                label: 'Log in',
                                showArrow: true,
                                height: m.buttonHeight,
                                fontSize: m.buttonText,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: buttonOpacity,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: SizedBox(
                              width: double.infinity,
                              height: m.buttonHeight,
                              child: OutlinePillButton(
                                label: 'Create account',
                                height: m.buttonHeight,
                                fontSize: m.buttonText,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: m.bottomGap),
                    ],
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

class WelcomeHeroClipper extends CustomClipper<Path> {
  const WelcomeHeroClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 18);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 52,
      size.width,
      size.height - 18,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class EzFinanzLogo extends StatelessWidget {
  const EzFinanzLogo({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        'assets/ezfinanz_wordmark.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.showSkip = false,
    this.skipTextSize = 16,
    this.onSkip,
    this.showBack = false,
    this.onBack,
  });

  final bool showSkip;
  final double skipTextSize;
  final VoidCallback? onSkip;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: showBack ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !showBack,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
                tooltip: 'Previous slide',
                onPressed: onBack,
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),
          ),
          if (showSkip)
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: primaryBlue,
                minimumSize: const Size(48, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: skipTextSize,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                  height: 1,
                  fontFamily: 'Inter',
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4.5),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFF0B53A0)
                : const Color(0xFF0B53A0).withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.height,
    required this.fontSize,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: bgWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Row(
            key: ValueKey(label),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: bgWhite,
                  letterSpacing: 0.1,
                  fontFamily: 'Inter',
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8),
                Text(
                  '→',
                  style: TextStyle(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.w500,
                    color: bgWhite,
                    height: 0.9,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.height,
    required this.fontSize,
  });

  final String label;
  final VoidCallback onPressed;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          backgroundColor: bgWhite,
          padding: EdgeInsets.zero,
          side: const BorderSide(color: primaryBlue, width: 1.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: primaryBlue,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
