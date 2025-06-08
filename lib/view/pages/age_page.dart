import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitstart_project/core/theme/colors.dart';
import 'package:fitstart_project/core/theme/text_styles.dart';
import 'package:fitstart_project/view/common_widgets/input_field.dart';
import 'package:fitstart_project/view/common_widgets/next_button.dart';

class AgePage extends StatefulWidget {
  final Function(String) onSubmitted;

  const AgePage({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage>
    with TickerProviderStateMixin {
  final TextEditingController _ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late AnimationController _slideController;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isAgeValid = false;

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
    
    _ageController.addListener(_validateAge);
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _validateAge() {
    final age = _ageController.text.trim();
    final isValid = age.isNotEmpty && 
                   int.tryParse(age) != null && 
                   int.parse(age) >= 13 && 
                   int.parse(age) <= 100;
    
    if (isValid != _isAgeValid) {
      setState(() {
        _isAgeValid = isValid;
      });
    }
  }

  String? _ageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }
    
    if (age < 13 || age > 100) {
      return 'Age must be between 13-100 years';
    }
    
    return null;
  }

  void _submitAge() {
    if (_formKey.currentState?.validate() == true && _isAgeValid) {
      widget.onSubmitted(_ageController.text.trim());
    }
  }

  String _getAgeGroup(int age) {
    if (age < 18) return 'Teen';
    if (age < 30) return 'Young Adult';
    if (age < 50) return 'Adult';
    if (age < 65) return 'Middle Age';
    return 'Senior';
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
                          'What\'s your age?',
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
                          'Age helps us recommend appropriate exercises and intensity levels for your fitness journey.',
                          style: FitStartTextStyles.body1.copyWith(
                            color: FitStartColors.white.withAlpha((0.7*255).toInt()),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isKeyboardVisible ? 40 : 60),
                    
                    // Age input field
                    InputField(
                      label: 'Age',
                      hint: 'Enter your age',
                      suffix: 'years',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (value) => _validateAge(),
                      validator: _ageValidator,
                    ),
                    
                    // Flexible spacer that adapts to keyboard
                    if (!isKeyboardVisible) 
                      const Spacer()
                    else 
                      SizedBox(height: _isAgeValid ? 24 : 40),
                    
                    // Animated age visualization
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _isAgeValid ? null : 0,
                      child: _isAgeValid ? Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: FitStartColors.green.withAlpha((0.1*255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: FitStartColors.green.withAlpha((0.3*255).toInt()),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.cake_outlined,
                                  color: FitStartColors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${_ageController.text} years old',
                                  style: FitStartTextStyles.body1.copyWith(
                                    color: FitStartColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.groups_outlined,
                                  color: FitStartColors.green.withAlpha((0.7*255).toInt()),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Age Group: ${_getAgeGroup(int.parse(_ageController.text))}',
                                  style: FitStartTextStyles.body2.copyWith(
                                    color: FitStartColors.green.withAlpha((0.8*255).toInt()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) : const SizedBox.shrink(),
                    ),
                    
                    // Complete button
                    NextButton(
                      onPressed: _submitAge,
                      isEnabled: _isAgeValid,
                      text: 'Complete',
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