import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:five/model/player_history_data.dart';
import 'package:five/util/constant/preferences_keys.dart';
import 'package:five/util/handler/shared_preferences_handler.dart';

part 'player_history_store.g.dart';

class PlayerHistoryStore = _PlayerHistoryStore with _$PlayerHistoryStore;

abstract class _PlayerHistoryStore with Store {

  @observable
  PlayerHistoryData _playerHistory = PlayerHistoryData();

  @computed
  PlayerHistoryData get playerHistory => _playerHistory;

  @action
  void _setPlayerHistory(PlayerHistoryData playerHistory) =>
      _playerHistory = playerHistory;

  Future<void> fetchPlayerHistory() async {
    var history = await SharedPreferencesHandler.getStringKeyPrefs(
        SharedPreferencesKeys.playerHistory
    );

    if (history.isNotEmpty) {
      _setPlayerHistory(PlayerHistoryData.fromJson(jsonDecode(history)));
    }
  }

  Future<void> updatePlayerHistory(int? attempts) async {
    var playerHistory = _playerHistory;

    if (attempts != null) {
      playerHistory.updateWins();
      playerHistory.updateAttempts(attempts);
      playerHistory.updateCurrentSequence();
      playerHistory.checkBestSequence();
    } else {
      playerHistory.updateDefeats();
      playerHistory.resetCurrentSequence();
    }

    _setPlayerHistory(playerHistory);

    await SharedPreferencesHandler.saveStringPrefs(
        SharedPreferencesKeys.playerHistory,
        jsonEncode(playerHistory)
    );
  }
}
