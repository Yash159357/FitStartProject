import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class NextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isEnabled;
  final String text;

  const NextButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.text = 'Next',
  });

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    // Start animation
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()
                ..scale(_isPressed ? 0.95 : 1.0),
              child: GestureDetector(
                onTapDown: widget.isEnabled ? _handleTapDown : null,
                onTapUp: widget.isEnabled ? _handleTapUp : null,
                onTapCancel: widget.isEnabled ? _handleTapCancel : null,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: widget.isEnabled ? 1.0 : 0.5,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: widget.isEnabled
                          ? const LinearGradient(
                              colors: [
                                FitStartColors.greenLight,
                                FitStartColors.green,
                                FitStartColors.greenDark,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: widget.isEnabled 
                          ? null 
                          : FitStartColors.lightGrey.withAlpha((0.3 * 255).toInt()),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: widget.isEnabled
                          ? [
                              BoxShadow(
                                color: FitStartColors.green.withAlpha((0.3 * 255).toInt()),
                                blurRadius: 12,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: FitStartColors.green.withAlpha((0.1 * 255).toInt()),
                                blurRadius: 24,
                                spreadRadius: 0,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.isEnabled ? widget.onPressed : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.text,
                                style: FitStartTextStyles.button.copyWith(
                                  color: widget.isEnabled 
                                      ? FitStartColors.darkGrey 
                                      : FitStartColors.white.withAlpha((0.5 * 255).toInt()),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: widget.isEnabled 
                                    ? FitStartColors.darkGrey 
                                    : FitStartColors.white.withAlpha((0.5 * 255).toInt()),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}