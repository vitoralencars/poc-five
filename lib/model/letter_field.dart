import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:five/animation/shake_animation.dart';
import '../util/app_colors.dart';

part 'letter_field.g.dart';

@JsonSerializable()
class LetterField {
  GlobalKey<ShakeAnimationState> key = GlobalKey<ShakeAnimationState>();
  String letter;
  int? background;
  int? borderColor;

  LetterField({
    required this.letter,
    this.background,
    this.borderColor
  });

  LetterField.updateBox(this.letter, this.background, this.borderColor);

  LetterField.updateLetter(this.letter) {
    background = AppColors.selectedRowLetterBoxBackground;
    borderColor = AppColors.selectedRowBorder;
  }

  factory LetterField.emptyState() => LetterField(
    letter: "",
    background: AppColors.letterBoxDefaultBackground
  );

  factory LetterField.fromJson(Map<String, dynamic> json) =>
      _$LetterFieldFromJson(json);

  Map toJson() => _$LetterFieldToJson(this);
}
