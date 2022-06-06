import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:five/model/daily_word.dart';
import 'package:five/service/usecase/fetch_daily_word_usecase.dart';
import 'package:five/util/app_colors.dart';
import 'package:five/util/handler/word_handler.dart';
import 'package:five/util/preferences_keys.dart';
import 'package:five/util/shared_preferences_helper.dart';
import 'package:five/widget/warning_banner.dart';
import '../di/service_locator.dart';
import '../model/keyboard_key.dart';
import '../model/letter_field.dart';
import '../model/player_history_data.dart';
import '../util/keyboard_keys.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  final _fetchWordUseCase = serviceLocator<FetchDailyWordUseCase>();

  final List<List<KeyboardKey>> keyboardKeysList = KeyboardKeys.getKeysList();

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  bool _isError = false;

  @computed
  bool get isError => _isError;

  @observable
  bool _isGuessingTriesFinished = false;

  @computed
  bool get isGuessingTriesFinished => _isGuessingTriesFinished;

  @observable
  bool _isFinishedDailyGame = false;

  @computed
  bool get isFinishedDailyGame => _isFinishedDailyGame;

  @observable
  DailyWord _dailyWord = DailyWord.emptyState();

  @computed
  DailyWord get dailyWord => _dailyWord;

  @observable
  bool _isFirstTime = false;

  @computed
  bool get isFirstTime => _isFirstTime;

  @observable
  WarningType _warningType = WarningType.hiddenState;

  @computed
  WarningType get warningType => _warningType;

  @observable
  ObservableList<LetterField> playedLetters = ObservableList.of(
    List<LetterField>.filled(
      30,
      LetterField.emptyState())
  );

  bool isWordGuessed = false;
  int currentIndex = 0;
  int _maxIndex = 4;
  int _minIndex = 0;
  int tries = 0;

  @action
  _setLoadingVisible(bool isLoading) => _isLoading = isLoading;

  @action
  _setErrorStatus(isError) => _isError = isError;

  @action
  _setIsGuessingTriesFinished(isGuessingTriesFinished) {
    _isGuessingTriesFinished = isGuessingTriesFinished;

    SharedPreferencesHelper.saveBooleanPrefs(
        SharedPreferencesKeys.dailyGuessingFinished,
        isGuessingTriesFinished
    );
  }

  @action
  _setIsFinishedDailyGame(isFinishedDailyGame) {
    _isFinishedDailyGame = isFinishedDailyGame;

    SharedPreferencesHelper.saveBooleanPrefs(
      SharedPreferencesKeys.finishedDailyGame,
      isFinishedDailyGame
    );
  }

  @action
  _setDailyWord(DailyWord dailyWord) => _dailyWord = dailyWord;

  @action
  _setIsFirstTime(bool isFirstTime) => _isFirstTime = isFirstTime;

  @action
  _setIsWordGuessed(bool isWordGuessed) => this.isWordGuessed = isWordGuessed;

  @action
  _setWarningType(WarningType warningType) {
    _warningType = warningType;
    _handleWarningBannerType();
  }

  @action
  _setPlayedLetters(ObservableList<LetterField> playedLetters) =>
      this.playedLetters = playedLetters;

  Future<void> fetchDailyWord() async {
    _setErrorStatus(false);
    _setLoadingVisible(true);

    DailyWord? dailyWord = await _fetchWordUseCase.execute();

    if (dailyWord != null) {
      _setDailyWord(dailyWord);
      await _fetchPlayedLettersList();
    } else {
      _setErrorStatus(true);
    }

    _setLoadingVisible(false);
  }

  Future<bool> _isValidWord() async {
    switch(await WordHandler.wordValidationResult(_getTyppedWord())) {
      case WordValidation.incompleteWord:
        _setWarningType(WarningType.incompleteWord);
        return false;
      case WordValidation.invalidWord:
        _setWarningType(WarningType.invalidWord);
        return false;
      default:
        return true;
    }
  }

  void shakeInvalidWord() {
    for (int i = _minIndex; i <=  _maxIndex; i++) {
      playedLetters[i].key.currentState?.shake();
    }
  }

  Future<void> _fetchPlayedLettersList() async {
    if (await _isAlreadyDailyPlayed()) {
      await _recoverLetterList();
    } else {
      await _checkIsFirstTime();
    }
  }

  Future<bool> _isAlreadyDailyPlayed() async {
    String lastPlayedWord = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.lastPlayedWord
    );

    if (lastPlayedWord != dailyWord.dailyWord) {
      await _resetSharedPreferences();
      return false;
    } else {
      return true;
    }
  }

  Future<void> _resetSharedPreferences() async {
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
  }

  Future<void> _recoverLetterList() async {
    var tries = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.triesList
    );

    if (tries.isNotEmpty) {
      var triesList = jsonDecode(tries);

      var keys = await SharedPreferencesHelper.getStringKeyPrefs(
        SharedPreferencesKeys.typedKeys
      );

      var keysList = jsonDecode(keys);

      await _checkDailyGameIsFinished();

      if (!isFinishedDailyGame) {
        currentIndex = await SharedPreferencesHelper.getIntKeyPrefs(
            SharedPreferencesKeys.currentIndex
        );
        _updateIndexes();
      }

      for (int i = 0; i < keyboardKeysList.length; i++) {
        keyboardKeysList[i] = List<KeyboardKey>.from(
          keysList[i].map((e) => KeyboardKey.fromJson(e))
        );
      }

      _setPlayedLetters(ObservableList.of(List<LetterField>.from(triesList.map((e) =>
        LetterField.fromJson(e))
      )));
    }
  }

  Future<void> _checkDailyGameIsFinished() async {
    bool isFinishedDailyGame = await SharedPreferencesHelper.getBoolKeyPrefs(
        SharedPreferencesKeys.finishedDailyGame
    );
    _setIsFinishedDailyGame(isFinishedDailyGame);

    if (_isFinishedDailyGame) {
      if (await _isWordMissed()) {
        _setWarningType(WarningType.wrongWord);
      } else {
        _setWarningType(WarningType.rightWord);
      }
    }
  }

  void _saveWordIsMissed(bool isWordMissed) async {
    await SharedPreferencesHelper.saveBooleanPrefs(
        SharedPreferencesKeys.wordMissed,
        isWordMissed
    );
  }

  Future<bool> _isWordMissed() async => await SharedPreferencesHelper
    .getBoolKeyPrefs(
      SharedPreferencesKeys.wordMissed
    );

  Future<void> _checkIsFirstTime() async {
    bool isFirstTime = !await SharedPreferencesHelper.getBoolKeyPrefs(
        SharedPreferencesKeys.notFirstTime
    );

    if (isFirstTime) {
      _setIsFirstTime(true);
      SharedPreferencesHelper.saveBooleanPrefs(
          SharedPreferencesKeys.notFirstTime,
          true
      );
    }

    _setIsFirstTime(false);
  }

  void _handleWarningBannerType() {
    switch (warningType) {
      case WarningType.wrongWord:
        break;
      case WarningType.hiddenState:
        break;
      default:
        _hideWarningBannerAfterTime(2);
    }
  }

  void _hideWarningBannerAfterTime(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      _setWarningType(WarningType.hiddenState);
    });
  }

  void _updateIndexes() {
    _maxIndex = currentIndex + 4;
    _minIndex = currentIndex;
  }

  void updateRowBorderColor() {
    for (int i = _minIndex; i <= _maxIndex; i++) {
      playedLetters[i] = LetterField.updateLetter("");
      _setPlayedLetters(playedLetters);
    }
  }

  void eraseLetter() {
    if (!isWordGuessed) {
      if (_isCurrentIndexLastIndexEmpty() || _isCurrentIndexBetweenMinMax()) {
        currentIndex--;
      }
      _updateLettersList("");
    }
  }

  bool _isCurrentIndexBetweenMinMax() =>
      currentIndex > _minIndex && currentIndex < _maxIndex;

  bool _isCurrentIndexLastIndexEmpty() => currentIndex == _maxIndex &&
      playedLetters[currentIndex].letter.isEmpty;

  Future<void> enterWord() async {
    var lastIndex = playedLetters.length - 1;
    var typpedWord = _getTyppedWord();

    if (_maxIndex <= lastIndex && await _isValidWord()) {
      _setIsWordGuessed(await WordHandler.isWordCorrect(
        playedLetters,
        keyboardKeysList,
        typpedWord,
        dailyWord.dailyWord,
        _minIndex
      ));
      if (!isWordGuessed) {
        if (_maxIndex < lastIndex) {
          currentIndex++;
          _updateIndexes();
          tries++;
          updateRowBorderColor();
        } else {
          _handleFinishedTries();
        }
      } else {
        _handleFinishedTries();
      }

      SharedPreferencesHelper.saveStringPrefs(
          SharedPreferencesKeys.typedKeys,
          jsonEncode(keyboardKeysList)
      );
      SharedPreferencesHelper.saveStringPrefs(
          SharedPreferencesKeys.triesList,
          jsonEncode(playedLetters)
      );
      SharedPreferencesHelper.saveIntPrefs(
          SharedPreferencesKeys.currentIndex,
          currentIndex
      );
    }
  }

  String _getTyppedWord() {
    String word = "";

    for (int i = _minIndex; i <= _maxIndex; i++) {
      word += playedLetters[i].letter;
    }

    return word;
  }

  void setLetter(String letter) {
    if (currentIndex < _maxIndex) {
      _updateLettersList(letter);
      currentIndex++;
    } else {
      if (playedLetters[currentIndex].letter.isEmpty) {
        _updateLettersList(letter);
      }
    }
  }

  void _updateLettersList(String letter) {
    playedLetters[currentIndex] = LetterField.updateLetter(letter);
    _setPlayedLetters(playedLetters);
  }

  void _handleFinishedTries() {
    if (!isWordGuessed) {
      _setWarningType(WarningType.wrongWord);
    }

    _saveWordIsMissed(!isWordGuessed);
    _setIsGuessingTriesFinished(true);
    _setIsFinishedDailyGame(true);
  }
}
