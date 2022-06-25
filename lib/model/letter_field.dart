import 'package:json_annotation/json_annotation.dart';
import '../util/constant/app_colors.dart';

part 'letter_field.g.dart';

@JsonSerializable()
class LetterField {
  String letter;
  int? background;
  int? borderColor;
  bool shake = false;

  LetterField({
    required this.letter,
    this.background,
    this.borderColor
  });

  LetterField.updateBox(this.letter, this.background, this.borderColor);

  LetterField.updateLetter(this.letter) {
    background = AppColors.selectedRowLetterBoxBackground;
    borderColor = AppColors.selectedRowLetterBoxBackground;
  }

  LetterField.selectField(this.letter) {
    background = AppColors.selectedRowLetterBoxBackground;
    borderColor = AppColors.defaultTextColor;
  }

  factory LetterField.emptyState() => LetterField(
    letter: "",
    background: AppColors.letterBoxDefaultBackground
  );

  factory LetterField.fromJson(Map<String, dynamic> json) =>
      _$LetterFieldFromJson(json);

  Map toJson() => _$LetterFieldToJson(this);
}
