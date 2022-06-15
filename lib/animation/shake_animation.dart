import 'package:five/util/constant/number_values.dart';
import 'package:flutter/material.dart';

class ShakeAnim extends StatelessWidget {
  const ShakeAnim({
    Key? key,
    this.duration = const Duration(
      milliseconds: NumberValues.letterShakeDuration
    ),
    this.deltaX = 40,
    this.curve = Curves.bounceOut,
    this.isShakeEnabled = false,
    required this.child,
  }) : super(key: key);

  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;
  final bool isShakeEnabled;

  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    if (!isShakeEnabled) {
      return Container(
        child: child,
      );
    } else {
      return TweenAnimationBuilder<double>(
        key: key,
        tween: Tween(begin: 0.0, end: 1.0),
        duration: duration,
        builder: (context, animation, child) =>
          Transform.translate(
            offset: Offset(deltaX * shake(animation), 0),
            child: child,
          ),
        child: child,
      );
    }
  }
}
