import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitstart_project/core/theme/colors.dart';
import 'package:fitstart_project/core/theme/text_styles.dart';
import 'package:fitstart_project/view/common_widgets/input_field.dart';
import 'package:fitstart_project/view/common_widgets/next_button.dart';

class WeightPage extends StatefulWidget {
  final Function(String) onSubmitted;

  const WeightPage({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage>
    with TickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late AnimationController _slideController;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isWeightValid = false;

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
    
    _weightController.addListener(_validateWeight);
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _validateWeight() {
    final weight = _weightController.text.trim();
    final isValid = weight.isNotEmpty && 
                   double.tryParse(weight) != null && 
                   double.parse(weight) >= 30 && 
                   double.parse(weight) <= 300;
    
    if (isValid != _isWeightValid) {
      setState(() {
        _isWeightValid = isValid;
      });
    }
  }

  String? _weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your weight';
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    
    if (weight < 30 || weight > 300) {
      return 'Weight must be between 30-300 kg';
    }
    
    return null;
  }

  void _submitWeight() {
    if (_formKey.currentState?.validate() == true && _isWeightValid) {
      widget.onSubmitted(_weightController.text.trim());
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
                          'What\'s your weight?',
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
                          'We use this information to create personalized workout plans and track your progress effectively.',
                          style: FitStartTextStyles.body1.copyWith(
                            color: FitStartColors.white.withAlpha((0.7*255).toInt()),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isKeyboardVisible ? 40 : 60),
                    
                    // Weight input field
                    InputField(
                      label: 'Weight',
                      hint: 'Enter your weight',
                      suffix: 'kg',
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      onChanged: (value) => _validateWeight(),
                      validator: _weightValidator,
                    ),
                    
                    // Flexible spacer that adapts to keyboard
                    if (!isKeyboardVisible) 
                      const Spacer()
                    else 
                      SizedBox(height: _isWeightValid ? 24 : 40),
                    
                    // Animated weight visualization
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _isWeightValid ? null : 0,
                      child: _isWeightValid ? Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: FitStartColors.green.withAlpha((0.1*255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: FitStartColors.green.withAlpha((0.3*255).toInt()),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.monitor_weight_outlined,
                              color: FitStartColors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${_weightController.text} kg',
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
                      onPressed: _submitWeight,
                      isEnabled: _isWeightValid,
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