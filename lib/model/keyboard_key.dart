import 'package:json_annotation/json_annotation.dart';

part 'keyboard_key.g.dart';

@JsonSerializable()
class KeyboardKey {
  @JsonKey(name: "letter")
  String letter;
  @JsonKey(name: "background")
  int? background;

  KeyboardKey({
    required this.letter,
    this.background
  });

  KeyboardKey.changeBackground(this.letter, this.background);

  factory KeyboardKey.fromJson(Map<String, dynamic> json) =>
      _$KeyboardKeyFromJson(json);

  Map toJson() => _$KeyboardKeyToJson(this);
}