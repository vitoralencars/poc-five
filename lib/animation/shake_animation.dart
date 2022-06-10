import 'package:flutter/material.dart';
import 'dart:math';
import 'package:five/animation/animation_controller.dart';

class ShakeAnimation extends StatefulWidget {
  const ShakeAnimation({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
  }) : super(key: key);
  final Widget child;
  final double shakeOffset;
  final int shakeCount;

  @override
  ShakeAnimationState createState() => ShakeAnimationState();
}

class ShakeAnimationState extends AnimationControllerState<ShakeAnimation> {
  ShakeAnimationState() : super(const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue =
        sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}
