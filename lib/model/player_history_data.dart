import 'package:json_annotation/json_annotation.dart';

part 'player_history_data.g.dart';

@JsonSerializable()
class PlayerHistoryData {
  int wins;
  int defeats;
  int currentSequence;
  int bestSequence;
  List<int> tries;

  PlayerHistoryData({
    this.wins = 0,
    this.defeats = 0,
    this.currentSequence = 0,
    this.bestSequence = 0,
    List<int>? tries
  }) : tries = tries ?? [0, 0, 0, 0, 0, 0];

  int playedGames() => wins + defeats;

  String winPercentage() {
    if (playedGames() == 0) return "0%";

    return "${((wins/playedGames())*100).toInt()}%".toString();
  }

  void updateWins() => wins++;

  void updateDefeats() => defeats++;

  void updateCurrentSequence() => currentSequence++;

  void resetCurrentSequence() => currentSequence = 0;

  void checkBestSequence() {
    if (currentSequence > bestSequence) {
      bestSequence++;
    }
  }

  void updateTries(int tryNumber) => tries[tryNumber]++;

  factory PlayerHistoryData.fromJson(Map<String, dynamic> json) =>
    _$PlayerHistoryDataFromJson(json);

  Map toJson() => _$PlayerHistoryDataToJson(this);

}
