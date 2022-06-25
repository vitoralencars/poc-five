import 'dart:math';
import 'package:five/animation/shake_animation.dart';
import 'package:flutter/material.dart';
import 'package:five/model/letter_field.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../util/constant/app_colors.dart';
import '../di/service_locator.dart';
import '../store/main_store.dart';

class LetterBox extends StatefulWidget {
  const LetterBox({
    Key? key,
    this.hideLetter = false,
    this.onTapped,
    required this.letterField,
    required this.index,
  }) : super(key: key);

  final bool hideLetter;
  final Function(int)? onTapped;
  final LetterField letterField;
  final int index;

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  final _mainStore = serviceLocator<MainStore>();

  @override
  Widget build(BuildContext context) {
    LetterField letterField = widget.letterField;

    return Center(
      child: GestureDetector(
        onTap: () => widget.onTapped?.call(widget.index),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(
                letterField.borderColor ??
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
                letterField.background ??
                    AppColors.letterBoxDefaultBackground
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Observer(
              builder: (_) {
                return ShakeAnim(
                  key: ValueKey(Random()),
                  isShakeEnabled: _mainStore.playedLetters[widget.index].shake,
                  child: Visibility(
                    visible: !widget.hideLetter,
                    child: Text(
                      letterField.letter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                );
              },
            )
          ),
        )
      )
    );
  }
}
