import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:pocs_flutter/model/daily_word.dart';
import 'package:pocs_flutter/service/usecase/fetch_daily_word_usecase.dart';
import 'package:pocs_flutter/util/preferences_keys.dart';
import 'package:pocs_flutter/util/shared_preferences_helper.dart';
import 'package:pocs_flutter/widget/warning_banner.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../di/service_locator.dart';
import '../model/keyboard_key.dart';
import '../model/letter_field.dart';
import '../model/player_history_data.dart';
import '../util/keyboard_keys.dart';

part 'home_view_model.g.dart';

class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store {
  final _fetchWordUseCase = serviceLocator<FetchDailyWordUseCase>();

  final List<List<KeyboardKey>> keyboardKeysList = KeyboardKeys.getKeysList();

  @observable
  bool isLoading = false;

  @observable
  bool isError = false;

  @observable
  bool isGuessingTriesFinished = false;

  @observable
  DailyWord dailyWord = DailyWord.emptyState();

  @observable
  int lastIndex = 0;

  @observable
  bool isFirstTime = false;

  @observable
  WarningType? warningType;

  @observable
  bool isWarningVisible = false;

  @observable
  List<LetterField>? playedLettersList;

  @observable
  PlayerHistoryData? playerHistory;

  @observable
  Map<String, List<String>>? validWords;

  @action
  _setLoadingVisible(bool isLoading) => this.isLoading = isLoading;

  @action
  _setErrorStatus(isError) => this.isError = isError;

  @action
  _setIsGuessingTriesFinished(isGuessingTriesFinished) =>
      this.isGuessingTriesFinished = isGuessingTriesFinished;

  @action
  _setDailyWord(DailyWord dailyWord) => this.dailyWord = dailyWord;

  @action
  _setLastIndex(int lastIndex) => this.lastIndex = lastIndex;

  @action
  _setIsFirstTime(bool isFirstTime) => this.isFirstTime = isFirstTime;

  @action
  _setWarningType(WarningType? warningType) {
    this.warningType = warningType;
    if (warningType != null) {
      _setIsWarningVisible(true);
      _hideWarningBannerAfterTime();
    }
  }

  @action
  _setIsWarningVisible(bool isWarningVisible) =>
      this.isWarningVisible = isWarningVisible;

  @action
  _setPlayedLettersList(List<LetterField>? playedLettersList) =>
      this.playedLettersList = playedLettersList;

  @action
  _setPlayerHistory(PlayerHistoryData playerHistory) =>
      this.playerHistory = playerHistory;

  @action
  _setValidWords(Map<String, List<String>> validWords) =>
      this.validWords = validWords;

  @action
  Future<void> fetchDailyWord() async {
    _setErrorStatus(false);
    _setLoadingVisible(true);

    DailyWord? dailyWord = await _fetchWordUseCase.execute();

    if (dailyWord != null) {
      _setDailyWord(dailyWord);
      await _fetchValidWords();
      await _fetchPlayedLettersList();
    } else {
      _setErrorStatus(true);
    }

    _setLoadingVisible(false);
  }

  Future<void> checkPlayerHistory() async {
    var history = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.playerHistory
    );

    if (history.isNotEmpty) {
      _setPlayerHistory(PlayerHistoryData.fromJson(jsonDecode(history)));
    }
  }

  bool isValidWord(String typpedWord) {
    if (typpedWord.length < 5) {
      _setWarningType(WarningType.incompleteWord);
      return false;
    }

    var validWordsNoDiactrics = validWords?['validWordsNoDiactrics'];

    if (validWordsNoDiactrics != null && !validWordsNoDiactrics.contains(typpedWord.toLowerCase())) {
      _setWarningType(WarningType.invalidWord);
      return false;
    }

    return true;
  }

  @action
  Future<void> _fetchValidWords() async {
    String wordsFile = await rootBundle.loadString('assets/validWords.txt');
    String wordsFileNoDiactrics = await rootBundle.loadString('assets/validWordsNoDiactrics.txt');
    List<String> validWordsList = wordsFile.split("\n").toList();
    List<String> validWordsNoDiactricsList = wordsFileNoDiactrics.split("\n").toList();

    _setValidWords({
      'validWords': validWordsList,
      'validWordsNoDiactrics': validWordsNoDiactricsList
    });

    // var t = wordsFile.split("\n").where((element) => element.length == 5 && !element.contains(".") && !element.contains("-")
    //     && !element.contains(" ") && element[0] != element[0].toUpperCase()).toList();
    // t.shuffle();
    //
    // String n = "";
    // String k = "";
    // t.forEach((element) {
    //   n += "$element\n";
    //   k += removeDiacritics(element) + "\n";
    // });
    // print(n);
    // print(k);
  }

  @action
  Future<void> _fetchPlayedLettersList() async {
    if (await _isAlreadyDailyPlayed()) {
      _setPlayedLettersList(await _recoverLetterList());
    } else {
      if (await _isFirstTime()) {
        _setIsFirstTime(true);
        SharedPreferencesHelper.saveBooleanPrefs(
            SharedPreferencesKeys.notFirstTime,
            true
        );
        _setIsFirstTime(false);
      }
    }
  }

  Future<bool> _isAlreadyDailyPlayed() async {
    String lastPlayedWord = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.lastPlayedWord
    );

    _setIsGuessingTriesFinished(await SharedPreferencesHelper.getBoolKeyPrefs(
        SharedPreferencesKeys.dailyGuessingFinished
    ));

    if (lastPlayedWord != dailyWord.dailyWord) {
      await SharedPreferencesHelper.saveStringPrefs(
          SharedPreferencesKeys.lastPlayedWord,
          dailyWord.dailyWord
      );
      await SharedPreferencesHelper.saveStringPrefs(
          SharedPreferencesKeys.triesList,
          ""
      );
      await SharedPreferencesHelper.saveBooleanPrefs(
          SharedPreferencesKeys.dailyGuessingFinished,
          false
      );

      _saveWordIsMissed(false);
      return false;
    } else {
      return true;
    }
  }

  Future<List<LetterField>?> _recoverLetterList() async {
    var tries = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.triesList
    );

    if (tries.isNotEmpty) {
      var triesList = jsonDecode(tries);

      var keys = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.typedKeys
      );

      var keysList = jsonDecode(keys);

      if (!isGuessingTriesFinished) {
        _setLastIndex(await SharedPreferencesHelper.getIntKeyPrefs(
          SharedPreferencesKeys.currentIndex
        ));

      } else if (await SharedPreferencesHelper.getBoolKeyPrefs(
        SharedPreferencesKeys.wordMissed
      )) {
        _setWarningType(WarningType.wrongWord);
      }

      for (int i = 0; i < keyboardKeysList.length; i++) {
        keyboardKeysList[i] = List<KeyboardKey>.from(
          keysList[i].map((e) => KeyboardKey.fromJson(e))
        );
      }

      return List<LetterField>.from(triesList.map((e) =>
        LetterField.fromJson(e))
      );

    } else {
      return null;
    }
  }

  void _saveWordIsMissed(bool isWordMissed) async {
    await SharedPreferencesHelper.saveBooleanPrefs(
        SharedPreferencesKeys.wordMissed,
        isWordMissed
    );
  }

  Future<bool> _isFirstTime() async {
    return !await SharedPreferencesHelper.getBoolKeyPrefs(
        SharedPreferencesKeys.notFirstTime
    );
  }

  void _hideWarningBannerAfterTime() {
    if (warningType != WarningType.wrongWord) {
      Future.delayed(const Duration(seconds: 2), () {
        _setIsWarningVisible(false);
        _setWarningType(null);
      });
    }
  }
}
