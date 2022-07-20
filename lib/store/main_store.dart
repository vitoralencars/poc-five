import 'dart:convert';
import 'package:five/util/constant/analytics_events.dart';
import 'package:five/util/constant/number_values.dart';
import 'package:five/util/handler/analytics_event_handler.dart';
import 'package:mobx/mobx.dart';
import 'package:five/model/daily_word.dart';
import 'package:five/service/usecase/fetch_daily_word_usecase.dart';
import 'package:five/util/handler/word_handler.dart';
import 'package:five/util/constant/preferences_keys.dart';
import 'package:five/util/handler/shared_preferences_handler.dart';
import 'package:five/widget/warning_banner.dart';
import '../di/service_locator.dart';
import '../model/keyboard_key.dart';
import '../model/letter_field.dart';
import '../util/constant/keyboard_keys.dart';

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
  bool _isGuessingAttemptsFinished = false;

  @computed
  bool get isGuessingAttemptsFinished => _isGuessingAttemptsFinished;

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
  bool _isWordGuessed = false;

  @computed
  bool get isWordGuessed => _isWordGuessed;

  @observable
  int _attempts = 0;

  @computed
  int get attempts => _attempts;

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

  int _currentIndex = 0;
  int _maxIndex = 4;
  int _minIndex = 0;

  @action
  _setLoadingVisible(bool isLoading) => _isLoading = isLoading;

  @action
  _setErrorStatus(isError) => _isError = isError;

  @action
  _setIsGuessingAttemptsFinished(isGuessingAttemptsFinished) {
    _isGuessingAttemptsFinished = isGuessingAttemptsFinished;

    SharedPreferencesHandler.saveBooleanPrefs(
      SharedPreferencesKeys.dailyGuessingFinished,
      isGuessingAttemptsFinished
    );
  }

  @action
  _setIsFinishedDailyGame(isFinishedDailyGame) {
    _isFinishedDailyGame = isFinishedDailyGame;

    SharedPreferencesHandler.saveBooleanPrefs(
      SharedPreferencesKeys.finishedDailyGame,
      isFinishedDailyGame
    );
  }

  @action
  _setDailyWord(DailyWord dailyWord) => _dailyWord = dailyWord;

  @action
  _setIsFirstTime(bool isFirstTime) => _isFirstTime = isFirstTime;

  @action
  _setIsWordGuessed(bool isWordGuessed) => _isWordGuessed = isWordGuessed;

  @action
  _setAttempts(int attempts) => _attempts = attempts;

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

  bool _isValidWord() {
    switch(WordHandler.wordValidationResult(_getTyppedWord())) {
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
      playedLetters[i].shake = true;
    }
    _resetShakeState();
  }

  void _resetShakeState() {
    Future.delayed(const Duration(
        milliseconds: NumberValues.letterShakeDuration
    ), () {
      for (int i = _minIndex; i <=  _maxIndex; i++) {
        playedLetters[i].shake = false;
      }
    });
  }

  Future<void> _fetchPlayedLettersList() async {
    if (await _isAlreadyDailyPlayed()) {
      await _recoverLetterList();
    } else {
      await _checkIsFirstTime();
    }
  }

  Future<bool> _isAlreadyDailyPlayed() async {
    String lastPlayedWord = await SharedPreferencesHandler.getStringKeyPrefs(
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
    await SharedPreferencesHandler.saveStringPrefs(
      SharedPreferencesKeys.lastPlayedWord,
      dailyWord.dailyWord
    );
    await SharedPreferencesHandler.saveStringPrefs(
      SharedPreferencesKeys.attemptsList,
      ""
    );
    await SharedPreferencesHandler.saveBooleanPrefs(
      SharedPreferencesKeys.dailyGuessingFinished,
      false
    );

    _saveWordIsMissed(false);
    _setIsFinishedDailyGame(false);
  }

  Future<void> _recoverLetterList() async {
    var storedAttempts = await SharedPreferencesHandler.getStringKeyPrefs(
        SharedPreferencesKeys.attemptsList
    );

    if (storedAttempts.isNotEmpty) {
      var attemptsList = jsonDecode(storedAttempts);

      var keys = await SharedPreferencesHandler.getStringKeyPrefs(
        SharedPreferencesKeys.typedKeys
      );

      var keysList = jsonDecode(keys);

      await _checkDailyGameIsFinished();

      int savedIndex = await SharedPreferencesHandler.getIntKeyPrefs(
          SharedPreferencesKeys.currentIndex
      );
      if (!isFinishedDailyGame) {
        _currentIndex = savedIndex;
        _updateIndexes();
      }

      _setAttempts(savedIndex~/5);

      for (int i = 0; i < keyboardKeysList.length; i++) {
        keyboardKeysList[i] = List<KeyboardKey>.from(
          keysList[i].map((e) => KeyboardKey.fromJson(e))
        );
      }

      _setPlayedLetters(ObservableList.of(List<LetterField>.from(attemptsList.map((e) =>
        LetterField.fromJson(e))
      )));
    }
  }

  Future<void> _checkDailyGameIsFinished() async {
    bool isFinishedDailyGame = await SharedPreferencesHandler.getBoolKeyPrefs(
        SharedPreferencesKeys.finishedDailyGame
    );
    _setIsFinishedDailyGame(isFinishedDailyGame);

    if (_isFinishedDailyGame) {
      if (await _isWordMissed()) {
        _setWarningType(WarningType.wrongWord);
      } else {
        _setIsWordGuessed(true);
        _setWarningType(WarningType.rightWord);
      }
    }
  }

  void _saveWordIsMissed(bool isWordMissed) async {
    await SharedPreferencesHandler.saveBooleanPrefs(
      SharedPreferencesKeys.wordMissed,
      isWordMissed
    );
  }

  Future<bool> _isWordMissed() async => await SharedPreferencesHandler
    .getBoolKeyPrefs(
      SharedPreferencesKeys.wordMissed
    );

  Future<void> _checkIsFirstTime() async {
    bool isFirstTime = !await SharedPreferencesHandler.getBoolKeyPrefs(
        SharedPreferencesKeys.notFirstTime
    );

    if (isFirstTime) {
      AnalyticsEventsHandler.logEvent(AnalyticsEvents.firstTimeUser);
      _setIsFirstTime(true);
      SharedPreferencesHandler.saveBooleanPrefs(
          SharedPreferencesKeys.notFirstTime,
          true
      );
    }

    _setIsFirstTime(false);
  }

  void _handleWarningBannerType() {
    switch (warningType) {
      case WarningType.wrongWord:
      case WarningType.rightWord:
      case WarningType.hiddenState:
        break;
      default:
        _hideWarningBannerAfterTime(NumberValues.warningBannerDuration);
    }
  }

  void _hideWarningBannerAfterTime(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      _setWarningType(WarningType.hiddenState);
    });
  }

  void _updateIndexes() {
    _maxIndex = _currentIndex + 4;
    _minIndex = _currentIndex;
  }

  void _logAttemptsAnalytics() {
    AnalyticsEventsHandler.logEvent(
      AnalyticsEvents.attemptNumber,
      data: <String, dynamic> {
        "daily_word": dailyWord.dailyWord,
        "attempt_word": _getTyppedWord(),
        "attempt_number": attempts
      }
    );
  }

  void updateRowBorderColor() {
    playedLetters[_minIndex] = LetterField.selectField("");
    for (int i = _minIndex + 1; i <= _maxIndex; i++) {
      playedLetters[i] = LetterField.updateLetter("");
      _setPlayedLetters(playedLetters);
    }
  }

  void selectBox(int boxIndex) {
    if (boxIndex >= _minIndex && boxIndex <= _maxIndex) {
      playedLetters[_currentIndex] = LetterField.updateLetter(
          playedLetters[_currentIndex].letter
      );
      _currentIndex = boxIndex;
      playedLetters[_currentIndex] = LetterField.selectField(
          playedLetters[_currentIndex].letter
      );

      _setPlayedLetters(playedLetters);
    }
  }

  void eraseLetter() {
    if (!isWordGuessed) {
      var changeSelected = _isCurrentIndexEmpty() &&
          _isCurrentIndexBiggerThanMin();

      if (changeSelected) {
        _currentIndex--;
      }

      _eraseLetter(changeSelected);
    }
  }

  bool _isCurrentIndexBiggerThanMin() => _currentIndex > _minIndex;

  bool _isCurrentIndexEmpty() => playedLetters[_currentIndex].letter.isEmpty;

  Future<void> enterWord() async {
    var lastIndex = playedLetters.length - 1;
    var typpedWord = _getTyppedWord();

    if (_maxIndex <= lastIndex && _isValidWord()) {
      _logAttemptsAnalytics();
      _setIsWordGuessed(await WordHandler.isWordCorrect(
        playedLetters,
        keyboardKeysList,
        typpedWord,
        dailyWord.dailyWord,
        _minIndex
      ));
      if (!isWordGuessed) {
        if (_maxIndex < lastIndex) {
          _currentIndex = _maxIndex + 1;
          _updateIndexes();
          _setAttempts(attempts + 1);
          updateRowBorderColor();
        } else {
          _handleFinishedAttempts();
        }
      } else {
        _handleFinishedAttempts();
      }

      SharedPreferencesHandler.saveStringPrefs(
        SharedPreferencesKeys.typedKeys,
        jsonEncode(keyboardKeysList)
      );
      SharedPreferencesHandler.saveStringPrefs(
        SharedPreferencesKeys.attemptsList,
        jsonEncode(playedLetters)
      );
      SharedPreferencesHandler.saveIntPrefs(
        SharedPreferencesKeys.currentIndex,
        _currentIndex
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
    _setLetter(letter);
    if (_currentIndex < _maxIndex) {
      _currentIndex++;
    }
  }

  void _setLetter(String letter) {
    if (_currentIndex < _maxIndex) {
      playedLetters[_currentIndex] = LetterField.updateLetter(letter);
      playedLetters[_currentIndex + 1] = LetterField.selectField(
        playedLetters[_currentIndex + 1].letter
      );
    } else {
      playedLetters[_currentIndex] = LetterField.selectField(letter);
    }

    _setPlayedLetters(playedLetters);
  }

  void _eraseLetter(bool changeSelected) {
    if (changeSelected && _currentIndex < _maxIndex) {
      playedLetters[_currentIndex + 1] = LetterField.updateLetter("");
    }

    playedLetters[_currentIndex] = LetterField.selectField("");

    _setPlayedLetters(playedLetters);
  }

  void _handleFinishedAttempts() {
    if (!isWordGuessed) {
      _setWarningType(WarningType.wrongWord);
      AnalyticsEventsHandler.logEvent(
          AnalyticsEvents.missedWord,
          data: <String, String> {
            "daily_word": dailyWord.dailyWord,
          }
      );
    } else {
      _setWarningType(WarningType.rightWord);
      AnalyticsEventsHandler.logEvent(
          AnalyticsEvents.rightWord,
          data: <String, dynamic> {
            "daily_word": dailyWord.dailyWord,
            "attempts": attempts
          }
      );
    }

    _saveWordIsMissed(!isWordGuessed);
    _setIsGuessingAttemptsFinished(true);
    _setIsFinishedDailyGame(true);
  }
}
