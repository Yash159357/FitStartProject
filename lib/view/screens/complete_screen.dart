import 'package:flutter/material.dart';
import 'package:fitstart_project/core/theme/colors.dart';
import 'package:fitstart_project/core/theme/text_styles.dart';

class CompleteScreen extends StatefulWidget {
  final String? height;
  final String? weight;
  final String? age;

  const CompleteScreen({
    super.key,
    this.height,
    this.weight,
    this.age,
  });

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _celebrationController;
  late AnimationController _statsController;
  late AnimationController _buttonController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _celebrationAnimation;
  late Animation<double> _statsSlideAnimation;
  late Animation<double> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Main content animations
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Celebration particles animation
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.easeOut,
      ),
    );

    // Stats animation
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _statsSlideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _statsController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Button animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonSlideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOutBack,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Start main animation
    _mainController.forward();

    // Start celebration particles
    await Future.delayed(const Duration(milliseconds: 400));
    _celebrationController.forward();

    // Start stats animation
    await Future.delayed(const Duration(milliseconds: 800));
    _statsController.forward();

    // Start button animation
    await Future.delayed(const Duration(milliseconds: 1000));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _celebrationController.dispose();
    _statsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _startFitnessJourney() {
    // Navigate to main app or home screen
    debugPrint('Starting fitness journey with:');
    debugPrint('Height: ${widget.height} cm');
    debugPrint('Weight: ${widget.weight} kg');
    debugPrint('Age: ${widget.age} years');

    // For now, show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Welcome to FitStart! Let\'s begin your journey.'),
        backgroundColor: FitStartColors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitStartColors.darkGrey,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _mainController,
            _celebrationController,
            _statsController,
            _buttonController,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                // Celebration particles
                ..._buildCelebrationParticles(),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),

                      // Success icon with scale animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  FitStartColors.green,
                                  FitStartColors.green.withAlpha((0.8 * 255).toInt()),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: FitStartColors.green.withAlpha((0.4 * 255).toInt()),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 60,
                              color: FitStartColors.darkGrey,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Title with slide animation
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            'You\'re All Set!',
                            style: FitStartTextStyles.heading1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Your fitness profile has been created successfully.\nTime to start your transformation!',
                            style: FitStartTextStyles.body1.copyWith(
                              color: FitStartColors.white.withAlpha((0.7 * 255).toInt()),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // User stats summary
                      Transform.translate(
                        offset: Offset(0, _statsSlideAnimation.value * 50),
                        child: Opacity(
                          opacity: 1 - _statsSlideAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: FitStartColors.white.withAlpha((0.05 * 255).toInt()),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: FitStartColors.green.withAlpha((0.2 * 255).toInt()),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Your Profile',
                                  style: FitStartTextStyles.body1.copyWith(
                                    color: FitStartColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                      icon: Icons.height,
                                      label: 'Height',
                                      value: '${widget.height ?? '--'} cm',
                                    ),
                                    _buildStatDivider(),
                                    _buildStatItem(
                                      icon: Icons.monitor_weight_outlined,
                                      label: 'Weight',
                                      value: '${widget.weight ?? '--'} kg',
                                    ),
                                    _buildStatDivider(),
                                    _buildStatItem(
                                      icon: Icons.cake_outlined,
                                      label: 'Age',
                                      value: '${widget.age ?? '--'} years',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // Start journey button
                      Transform.translate(
                        offset: Offset(0, _buttonSlideAnimation.value * 50),
                        child: Opacity(
                          opacity: (1 - _buttonSlideAnimation.value).clamp(0.0, 1.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _startFitnessJourney,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FitStartColors.green,
                                foregroundColor: FitStartColors.darkGrey,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Start My Fitness Journey',
                                style: FitStartTextStyles.button.copyWith(
                                  color: FitStartColors.darkGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
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

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: FitStartColors.green.withAlpha((0.8 * 255).toInt()),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: FitStartTextStyles.body1.copyWith(
            color: FitStartColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: FitStartTextStyles.body2.copyWith(
            color: FitStartColors.white.withAlpha((0.6 * 255).toInt()),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: FitStartColors.green.withAlpha((0.3 * 255).toInt()),
    );
  }

  List<Widget> _buildCelebrationParticles() {
    return List.generate(8, (index) {
      final delay = index * 0.1;
      final progress = (_celebrationAnimation.value - delay).clamp(0.0, 1.0);
      if (progress <= 0) return const SizedBox.shrink();

      final adjustedProgress = delay < 1.0 
          ? (progress / (1 - delay)).clamp(0.0, 1.0)
          : progress.clamp(0.0, 1.0);
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      // Ensure opacity is always within valid range
      final opacity = (1 - adjustedProgress * adjustedProgress).clamp(0.0, 1.0);
      final scale = (1 - adjustedProgress * 0.5).clamp(0.1, 1.0);

      return Positioned(
        left: screenWidth * (0.2 + (index % 3) * 0.3),
        top: screenHeight * (0.1 + adjustedProgress * 0.8),
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 8 + (index % 3) * 4,
              height: 8 + (index % 3) * 4,
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? FitStartColors.green
                    : FitStartColors.green.withAlpha((0.7 * 255).toInt()),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: FitStartColors.green.withAlpha((0.3 * 255).toInt()),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}