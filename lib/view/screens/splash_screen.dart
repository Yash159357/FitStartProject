import 'dart:math' as math;
import 'package:fitstart_project/view/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _backgroundGradient;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    
    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    // Background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _backgroundGradient = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.linear,
      ),
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start background and particles immediately
    _backgroundController.forward();
    _particleController.repeat();
    
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    // Start text animation
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    
    // Start pulse animation
    await Future.delayed(const Duration(milliseconds: 1200));
    _pulseController.repeat(reverse: true);
    
    // Navigate to onboarding after 4 seconds
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _textController,
          _backgroundController,
          _particleController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  FitStartColors.darkGrey.withAlpha((0.8 * 255).toInt()),
                  FitStartColors.darkGrey,
                  const Color(0xFF1A1A1A),
                ],
                stops: [
                  0.0,
                  0.6 + (_backgroundGradient.value * 0.4),
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated particles
                ...List.generate(12, (index) => _buildParticle(index)),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with multiple animations
                      Transform.scale(
                        scale: _logoScale.value * _pulseAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: Opacity(
                            opacity: _logoOpacity.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    FitStartColors.green,
                                    FitStartColors.greenLight,
                                    FitStartColors.green,
                                  ],
                                  stops: const [0.0, 0.7, 1.0],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: FitStartColors.green.withAlpha((0.4 * 255).toInt()),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: FitStartColors.green.withAlpha((0.2 * 255).toInt()),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                size: 60,
                                color: FitStartColors.darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // App name with slide animation
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: const Text(
                            'FitStart',
                            style: FitStartTextStyles.logo,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Tagline with delayed fade
                      FadeTransition(
                        opacity: _textOpacity,
                        child: const Text(
                          'YOUR FITNESS JOURNEY BEGINS',
                          style: FitStartTextStyles.tagline,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Loading indicator at bottom
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FitStartColors.green.withAlpha((0.8 * 255).toInt()),
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
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final size = 2.0 + random.nextDouble() * 4;
    final speed = 0.5 + random.nextDouble() * 0.5;
    
    return Positioned(
      left: MediaQuery.of(context).size.width * startX,
      top: MediaQuery.of(context).size.height * startY,
      child: Transform.translate(
        offset: Offset(
          math.sin(_particleAnimation.value * 2 * math.pi * speed) * 50,
          math.cos(_particleAnimation.value * 2 * math.pi * speed) * 30,
        ),
        child: Opacity(
          opacity: (math.sin(_particleAnimation.value * 2 * math.pi + index) + 1) / 4,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: FitStartColors.green.withAlpha((0.6 * 255).toInt()),
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
  }
}