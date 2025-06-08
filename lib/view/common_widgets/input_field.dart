import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hint;
  final String suffix;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.onChanged,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.validator,
    this.controller,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    
    // Start animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    widget.label,
                    style: FitStartTextStyles.body1.copyWith(
                      color: FitStartColors.white.withAlpha((0.8 * 255).toInt()),
                      fontSize: 14,
                    ),
                  ),
                ),
                
                // Input field
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: FitStartColors.lightGrey.withAlpha((0.3 * 255).toInt()),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isFocused 
                          ? FitStartColors.green 
                          : FitStartColors.lightGrey.withAlpha((0.3 * 255).toInt()),
                      width: _isFocused ? 2 : 1,
                    ),
                    boxShadow: _isFocused
                        ? [
                            BoxShadow(
                              color: FitStartColors.green.withAlpha((0.2 * 255).toInt()),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    validator: widget.validator,
                    onChanged: widget.onChanged,
                    style: FitStartTextStyles.body1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: FitStartTextStyles.body1.copyWith(
                        color: FitStartColors.white.withAlpha((0.4 * 255).toInt()),
                        fontSize: 18,
                      ),
                      suffixText: widget.suffix,
                      suffixStyle: FitStartTextStyles.body1.copyWith(
                        color: FitStartColors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}