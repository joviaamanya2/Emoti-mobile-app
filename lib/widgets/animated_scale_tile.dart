import 'package:flutter/material.dart';

class AnimatedScaleTile extends StatelessWidget {
  final bool isSelected;
  final Animation<double> scaleAnimation;
  final double width;
  final Widget child;

  const AnimatedScaleTile({super.key, required this.isSelected, required this.scaleAnimation, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, ch) {
        final scale = isSelected ? 1.0 : scaleAnimation.value;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.white : Colors.grey.shade300),
            ),
            child: ch,
          ),
        );
      },
      child: child,
    );
  }
}
