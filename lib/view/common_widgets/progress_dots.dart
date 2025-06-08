import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class ProgressDots extends StatefulWidget {
  final int currentPage;
  final int totalPages;

  const ProgressDots({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  State<ProgressDots> createState() => _ProgressDotsState();
}

class _ProgressDotsState extends State<ProgressDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.totalPages,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Animate current page
    _updateAnimations();
  }

  void _updateAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      if (i <= widget.currentPage) {
        _controllers[i].forward();
      } else {
        _controllers[i].reverse();
      }
    }
  }

  @override
  void didUpdateWidget(ProgressDots oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _updateAnimations();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalPages, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final isActive = index <= widget.currentPage;
            final progress = _animations[index].value;
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? FitStartColors.green.withAlpha(((0.2 + (0.8 * progress)) * 255).toInt())
                      : FitStartColors.lightGrey.withAlpha((0.3 * 255).toInt()),
                  boxShadow: isActive && progress > 0.5
                      ? [
                          BoxShadow(
                            color: FitStartColors.green.withAlpha((0.3 * 255).toInt()),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: isActive
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              FitStartColors.green.withAlpha((0.8 * 255).toInt()),
                              FitStartColors.green,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }
}