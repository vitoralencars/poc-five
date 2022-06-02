import 'package:flutter/material.dart';
import 'package:pocs_flutter/animation/shake_animation.dart';
import 'package:pocs_flutter/model/letter_field.dart';
import 'package:pocs_flutter/util/app_colors.dart';

class LetterBox extends StatefulWidget {
  const LetterBox({
    Key? key,
    required this.letterField,
  }) : super(key: key);

  final LetterField letterField;

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {

  final shakeKey = GlobalKey<ShakeAnimationState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.homeBackground),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: widget.letterField.borderColor != null ?
                  Color(widget.letterField.borderColor!) : Colors.transparent,
                width: 2
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          elevation: 5,
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(widget.letterField.background),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ShakeAnimation(
              key: widget.letterField.key,
              shakeCount: 3,
              shakeOffset: 10,
              shakeDuration: const Duration(milliseconds: 500),
              child: Text(
                widget.letterField.letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                )
              )
            ),
          ),
        )
      )
    );
  }
}
