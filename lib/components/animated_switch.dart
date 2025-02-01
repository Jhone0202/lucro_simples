import 'package:flutter/material.dart';

class AnimatedSwitch extends StatefulWidget {
  const AnimatedSwitch({
    super.key,
    required this.option1,
    required this.option2,
    required this.onChanged,
  });

  final String option1;
  final String option2;
  final ValueChanged<String> onChanged;

  @override
  State<AnimatedSwitch> createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch>
    with SingleTickerProviderStateMixin {
  late bool isOption1;
  late AnimationController _animationController;
  late Animation<double> _thumbPosition;

  @override
  void initState() {
    super.initState();
    isOption1 = true; // Default selection
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _thumbPosition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSwitch() {
    setState(() {
      isOption1 = !isOption1;
      if (isOption1) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      widget.onChanged(isOption1 ? widget.option1 : widget.option2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      onHorizontalDragEnd: (_) => toggleSwitch(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _thumbPosition,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment(_thumbPosition.value * 2 - 1, 0),
                      child: Container(
                        width: constraints.maxWidth / 2,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.option1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isOption1
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.option2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isOption1
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
