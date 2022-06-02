import 'package:json_annotation/json_annotation.dart';

part 'daily_word.g.dart';

@JsonSerializable()
class DailyWord {
  @JsonKey(name: "dailyWord")
  final String dailyWord;
  @JsonKey(name: "nextWordRemainingTime")
  final String nextWordRemainingTime;

  DailyWord({
    required this.dailyWord,
    required this.nextWordRemainingTime
  });

  factory DailyWord.emptyState() => DailyWord(
      dailyWord: "",
      nextWordRemainingTime: ""
  );

  factory DailyWord.fromJson(Map<String, dynamic> json) =>
      _$DailyWordFromJson(json);
}
