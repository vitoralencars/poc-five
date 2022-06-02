// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeViewModel on _HomeViewModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomeViewModelBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isErrorAtom =
      Atom(name: '_HomeViewModelBase.isError', context: context);

  @override
  bool get isError {
    _$isErrorAtom.reportRead();
    return super.isError;
  }

  @override
  set isError(bool value) {
    _$isErrorAtom.reportWrite(value, super.isError, () {
      super.isError = value;
    });
  }

  late final _$isGuessingTriesFinishedAtom = Atom(
      name: '_HomeViewModelBase.isGuessingTriesFinished', context: context);

  @override
  bool get isGuessingTriesFinished {
    _$isGuessingTriesFinishedAtom.reportRead();
    return super.isGuessingTriesFinished;
  }

  @override
  set isGuessingTriesFinished(bool value) {
    _$isGuessingTriesFinishedAtom
        .reportWrite(value, super.isGuessingTriesFinished, () {
      super.isGuessingTriesFinished = value;
    });
  }

  late final _$dailyWordAtom =
      Atom(name: '_HomeViewModelBase.dailyWord', context: context);

  @override
  DailyWord get dailyWord {
    _$dailyWordAtom.reportRead();
    return super.dailyWord;
  }

  @override
  set dailyWord(DailyWord value) {
    _$dailyWordAtom.reportWrite(value, super.dailyWord, () {
      super.dailyWord = value;
    });
  }

  late final _$lastIndexAtom =
      Atom(name: '_HomeViewModelBase.lastIndex', context: context);

  @override
  int get lastIndex {
    _$lastIndexAtom.reportRead();
    return super.lastIndex;
  }

  @override
  set lastIndex(int value) {
    _$lastIndexAtom.reportWrite(value, super.lastIndex, () {
      super.lastIndex = value;
    });
  }

  late final _$isFirstTimeAtom =
      Atom(name: '_HomeViewModelBase.isFirstTime', context: context);

  @override
  bool get isFirstTime {
    _$isFirstTimeAtom.reportRead();
    return super.isFirstTime;
  }

  @override
  set isFirstTime(bool value) {
    _$isFirstTimeAtom.reportWrite(value, super.isFirstTime, () {
      super.isFirstTime = value;
    });
  }

  late final _$warningTypeAtom =
      Atom(name: '_HomeViewModelBase.warningType', context: context);

  @override
  WarningType? get warningType {
    _$warningTypeAtom.reportRead();
    return super.warningType;
  }

  @override
  set warningType(WarningType? value) {
    _$warningTypeAtom.reportWrite(value, super.warningType, () {
      super.warningType = value;
    });
  }

  late final _$isWarningVisibleAtom =
      Atom(name: '_HomeViewModelBase.isWarningVisible', context: context);

  @override
  bool get isWarningVisible {
    _$isWarningVisibleAtom.reportRead();
    return super.isWarningVisible;
  }

  @override
  set isWarningVisible(bool value) {
    _$isWarningVisibleAtom.reportWrite(value, super.isWarningVisible, () {
      super.isWarningVisible = value;
    });
  }

  late final _$playedLettersListAtom =
      Atom(name: '_HomeViewModelBase.playedLettersList', context: context);

  @override
  List<LetterField>? get playedLettersList {
    _$playedLettersListAtom.reportRead();
    return super.playedLettersList;
  }

  @override
  set playedLettersList(List<LetterField>? value) {
    _$playedLettersListAtom.reportWrite(value, super.playedLettersList, () {
      super.playedLettersList = value;
    });
  }

  late final _$playerHistoryAtom =
      Atom(name: '_HomeViewModelBase.playerHistory', context: context);

  @override
  PlayerHistoryData? get playerHistory {
    _$playerHistoryAtom.reportRead();
    return super.playerHistory;
  }

  @override
  set playerHistory(PlayerHistoryData? value) {
    _$playerHistoryAtom.reportWrite(value, super.playerHistory, () {
      super.playerHistory = value;
    });
  }

  late final _$validWordsAtom =
      Atom(name: '_HomeViewModelBase.validWords', context: context);

  @override
  Map<String, List<String>>? get validWords {
    _$validWordsAtom.reportRead();
    return super.validWords;
  }

  @override
  set validWords(Map<String, List<String>>? value) {
    _$validWordsAtom.reportWrite(value, super.validWords, () {
      super.validWords = value;
    });
  }

  late final _$fetchDailyWordAsyncAction =
      AsyncAction('_HomeViewModelBase.fetchDailyWord', context: context);

  @override
  Future<void> fetchDailyWord() {
    return _$fetchDailyWordAsyncAction.run(() => super.fetchDailyWord());
  }

  late final _$_fetchValidWordsAsyncAction =
      AsyncAction('_HomeViewModelBase._fetchValidWords', context: context);

  @override
  Future<void> _fetchValidWords() {
    return _$_fetchValidWordsAsyncAction.run(() => super._fetchValidWords());
  }

  late final _$_fetchPlayedLettersListAsyncAction = AsyncAction(
      '_HomeViewModelBase._fetchPlayedLettersList',
      context: context);

  @override
  Future<void> _fetchPlayedLettersList() {
    return _$_fetchPlayedLettersListAsyncAction
        .run(() => super._fetchPlayedLettersList());
  }

  late final _$_HomeViewModelBaseActionController =
      ActionController(name: '_HomeViewModelBase', context: context);

  @override
  dynamic _setLoadingVisible(bool isLoading) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setLoadingVisible');
    try {
      return super._setLoadingVisible(isLoading);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setErrorStatus(dynamic isError) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setErrorStatus');
    try {
      return super._setErrorStatus(isError);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setIsGuessingTriesFinished(dynamic isGuessingTriesFinished) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setIsGuessingTriesFinished');
    try {
      return super._setIsGuessingTriesFinished(isGuessingTriesFinished);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setDailyWord(DailyWord dailyWord) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setDailyWord');
    try {
      return super._setDailyWord(dailyWord);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setLastIndex(int lastIndex) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setLastIndex');
    try {
      return super._setLastIndex(lastIndex);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setIsFirstTime(bool isFirstTime) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setIsFirstTime');
    try {
      return super._setIsFirstTime(isFirstTime);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setWarningType(WarningType? warningType) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setWarningType');
    try {
      return super._setWarningType(warningType);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setIsWarningVisible(bool isWarningVisible) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setIsWarningVisible');
    try {
      return super._setIsWarningVisible(isWarningVisible);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setPlayedLettersList(List<LetterField>? playedLettersList) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setPlayedLettersList');
    try {
      return super._setPlayedLettersList(playedLettersList);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setPlayerHistory(PlayerHistoryData playerHistory) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setPlayerHistory');
    try {
      return super._setPlayerHistory(playerHistory);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setValidWords(Map<String, List<String>> validWords) {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase._setValidWords');
    try {
      return super._setValidWords(validWords);
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isError: ${isError},
isGuessingTriesFinished: ${isGuessingTriesFinished},
dailyWord: ${dailyWord},
lastIndex: ${lastIndex},
isFirstTime: ${isFirstTime},
warningType: ${warningType},
isWarningVisible: ${isWarningVisible},
playedLettersList: ${playedLettersList},
playerHistory: ${playerHistory},
validWords: ${validWords}
    ''';
  }
}
