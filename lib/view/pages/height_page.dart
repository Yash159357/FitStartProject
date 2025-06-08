import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitstart_project/core/theme/colors.dart';
import 'package:fitstart_project/core/theme/text_styles.dart';
import 'package:fitstart_project/view/common_widgets/input_field.dart';
import 'package:fitstart_project/view/common_widgets/next_button.dart';

class HeightPage extends StatefulWidget {
  final Function(String) onSubmitted;

  const HeightPage({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage>
    with TickerProviderStateMixin {
  final TextEditingController _heightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late AnimationController _slideController;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isHeightValid = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));
    
    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _heightController.addListener(_validateHeight);
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _validateHeight() {
    final height = _heightController.text.trim();
    final isValid = height.isNotEmpty && 
                   double.tryParse(height) != null && 
                   double.parse(height) >= 100 && 
                   double.parse(height) <= 250;
    
    if (isValid != _isHeightValid) {
      setState(() {
        _isHeightValid = isValid;
      });
    }
  }

  String? _heightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your height';
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }
    
    if (height < 100 || height > 250) {
      return 'Height must be between 100-250 cm';
    }
    
    return null;
  }

  void _submitHeight() {
    if (_formKey.currentState?.validate() == true && _isHeightValid) {
      widget.onSubmitted(_heightController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Scaffold(
      backgroundColor: FitStartColors.darkGrey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom - 48 - 110,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isKeyboardVisible ? 20 : 40),
                    
                    // Title with slide animation
                    SlideTransition(
                      position: _titleSlideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'What\'s your height?',
                          style: FitStartTextStyles.heading1,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subtitle with slide animation
                    SlideTransition(
                      position: _subtitleSlideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'This helps us personalize your fitness journey and calculate accurate metrics.',
                          style: FitStartTextStyles.body1.copyWith(
                            color: FitStartColors.white.withAlpha((0.7*255).toInt()),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isKeyboardVisible ? 40 : 60),
                    
                    // Height input field
                    InputField(
                      label: 'Height',
                      hint: 'Enter your height',
                      suffix: 'cm',
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      onChanged: (value) => _validateHeight(),
                      validator: _heightValidator,
                    ),
                    
                    // Flexible spacer that adapts to keyboard
                    if (!isKeyboardVisible) 
                      const Spacer()
                    else 
                      SizedBox(height: _isHeightValid ? 24 : 40),
                    
                    // Animated height visualization
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _isHeightValid ? null : 0,
                      child: _isHeightValid ? Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: FitStartColors.green.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: FitStartColors.green.withAlpha((0.3 * 255).toInt()),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.height,
                              color: FitStartColors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${_heightController.text} cm',
                              style: FitStartTextStyles.body1.copyWith(
                                color: FitStartColors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ) : const SizedBox.shrink(),
                    ),
                    
                    // Next button
                    NextButton(
                      onPressed: _submitHeight,
                      isEnabled: _isHeightValid,
                      text: 'Next',
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}