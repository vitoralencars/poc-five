import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:pocs_flutter/model/player_history_data.dart';
import 'package:pocs_flutter/util/preferences_keys.dart';
import 'package:pocs_flutter/util/shared_preferences_helper.dart';

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
    var history = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.playerHistory
    );

    if (history.isNotEmpty) {
      _setPlayerHistory(PlayerHistoryData.fromJson(jsonDecode(history)));
    }
  }

  Future<void> updatePlayerHistory(int? tries) async {
    var playerHistory = _playerHistory;

    if (tries != null) {
      playerHistory.updateWins();
      playerHistory.updateTries(tries);
      playerHistory.updateCurrentSequence();
      playerHistory.checkBestSequence();
    } else {
      playerHistory.updateDefeats();
      playerHistory.resetCurrentSequence();
    }

    _setPlayerHistory(playerHistory);

    await SharedPreferencesHelper.saveStringPrefs(
        SharedPreferencesKeys.playerHistory,
        jsonEncode(playerHistory)
    );
  }
}
