import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final Color color;
  final double marginVertical;

  const DottedDivider({
    super.key,
    this.dotSize = 8.0,
    this.spacing = 4.0,
    this.color = Colors.black12,
    this.marginVertical = 8,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dotsCount = (constraints.maxWidth / (dotSize + spacing)).floor();
        return Padding(
          padding: EdgeInsets.symmetric(vertical: marginVertical),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dotsCount,
              (index) => Container(
                width: dotSize,
                height: 1,
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
