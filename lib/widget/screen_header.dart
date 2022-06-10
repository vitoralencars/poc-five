import 'package:five/widget/border_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    Key? key,
    required this.onHistoryPressed,
    required this.onInstructionsPressed,
  }) : super(key: key);

  final VoidCallback onHistoryPressed;
  final VoidCallback onInstructionsPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BorderIconButton(
          icon: Icons.history,
          onPressed: onHistoryPressed,
        ),
        SvgPicture.asset(
          'assets/images/five_logo.svg',
          height: 30,
          alignment: Alignment.center,
        ),
        BorderIconButton(
          icon: Icons.question_mark,
          onPressed: onInstructionsPressed,
        )
      ],
    );
  }
}
