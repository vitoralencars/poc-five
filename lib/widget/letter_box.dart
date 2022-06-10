import 'dart:math';

import 'package:five/animation/shake.dart';
import 'package:flutter/material.dart';
import 'package:five/animation/shake_animation.dart';
import 'package:five/model/letter_field.dart';
import 'package:five/util/app_colors.dart';

class LetterBox extends StatefulWidget {
  const LetterBox({
    Key? key,
    required this.letterField,
    required this.index,
  }) : super(key: key);

  final LetterField letterField;
  final int index;

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {

  @override
  Widget build(BuildContext context) {
    Key sKey = ValueKey(widget.index);

    return Center(
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(
                  widget.letterField.borderColor ??
                  AppColors.transparent
                ),
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
              color: Color(
                widget.letterField.background ??
                AppColors.letterBoxDefaultBackground
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            /*child: ShakeAnim(
              //key: widget.letterField.key,
              key: ValueKey(10),
              child: Text(
                  widget.letterField.letter,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),*/
            child: ShakeAnimation(
                key: ValueKey(Random(1000)),
                shakeCount: 3,
                shakeOffset: 10,
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
    );
  }
}
