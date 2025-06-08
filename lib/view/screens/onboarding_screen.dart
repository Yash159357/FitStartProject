import 'package:fitstart_project/view/screens/complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitstart_project/core/theme/colors.dart';
import 'package:fitstart_project/view/pages/height_page.dart';
import 'package:fitstart_project/view/pages/weight_page.dart';
import 'package:fitstart_project/view/pages/age_page.dart';
import 'package:fitstart_project/view/common_widgets/progress_dots.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // User data storage
  String? height;
  String? weight;
  String? age;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start entrance animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // All data collected, navigate to completion or main app
      _completeOnboarding();
    }
  }

  // void _completeOnboarding() {
  //   debugPrint('Onboarding completed!');
  //   debugPrint('Height: $height, Weight: $weight, Age: $age');

  //   // For now, just show a completion message
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Onboarding completed!'),
  //       backgroundColor: FitStartColors.green,
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }
  void _completeOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                CompleteScreen(height: height, weight: weight, age: age),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onHeightSubmitted(String value) {
    setState(() {
      height = value;
    });
    _nextPage();
  }

  void _onWeightSubmitted(String value) {
    setState(() {
      weight = value;
    });
    _nextPage();
  }

  void _onAgeSubmitted(String value) {
    setState(() {
      age = value;
    });
    _nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitStartColors.darkGrey,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button (hidden on first page)
                    SizedBox(
                      width: 40,
                      child:
                          _currentPage > 0
                              ? IconButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: FitStartColors.white,
                                  size: 20,
                                ),
                              )
                              : null,
                    ),

                    // Progress dots
                    ProgressDots(currentPage: _currentPage, totalPages: 3),

                    // Skip button
                    SizedBox(
                      width: 60,
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: FitStartColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView with input pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable swipe
                  children: [
                    HeightPage(onSubmitted: _onHeightSubmitted),
                    WeightPage(onSubmitted: _onWeightSubmitted),
                    AgePage(onSubmitted: _onAgeSubmitted),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
