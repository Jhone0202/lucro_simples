import 'package:flutter/material.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    this.currentIndex = 0,
    this.length = 4,
    this.padding,
  });

  final int currentIndex;
  final int length;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          length,
          (index) => AnimatedContainer(
            duration: Durations.medium1,
            curve: Curves.ease,
            width: index == currentIndex ? 20 : 8,
            height: 8,
            margin: index < length ? const EdgeInsets.only(right: 4) : null,
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? AppTheme.colors.primary
                  : AppTheme.colors.stroke,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
