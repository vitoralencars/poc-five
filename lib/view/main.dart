import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:pocs_flutter/model/daily_word.dart';
import 'package:pocs_flutter/model/keyboard_key.dart';
import 'package:pocs_flutter/model/letter_field.dart';
import 'package:pocs_flutter/model/player_history_data.dart';
import 'package:pocs_flutter/viewmodel/home_view_model.dart';
import 'package:pocs_flutter/widget/border_icon_button.dart';
import 'package:pocs_flutter/widget/countdown_timer.dart';
import 'package:pocs_flutter/widget/error_screen.dart';
import 'package:pocs_flutter/widget/grid_letter_boxes.dart';
import 'package:pocs_flutter/widget/keyboard.dart';
import 'package:diacritic/diacritic.dart';
import 'package:pocs_flutter/widget/loading_lottie.dart';
import 'package:pocs_flutter/widget/player_history.dart';
import 'package:pocs_flutter/widget/tutorial_dialog.dart';
import 'package:pocs_flutter/widget/warning_banner.dart';
import 'package:pocs_flutter/util/app_colors.dart';
import 'package:pocs_flutter/util/preferences_keys.dart';
import 'package:pocs_flutter/util/keyboard_keys.dart';
import 'dart:convert';
import 'package:pocs_flutter/util/shared_preferences_helper.dart';

import '../di/service_locator.dart';

void main() async {
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final int wordLength = 5;
  final int attemptsAllowed = 6;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _viewModel = serviceLocator<HomeViewModel>();

  int _currentIndex = 0;
  int _minIndex = 0;
  int _maxIndex = 4;
  int tries = 0;
  List _validWords = [];
  List _validWordsNoDiactrics = [];
  bool _isWarningBannerVisible = false;
  bool _isWordGuessed = false;
  bool _isGuessingTriesFinished = false;
  BuildContext? tutorialDialogContext;
  PlayerHistoryData playerHistory = PlayerHistoryData();
  WarningType _warningType = WarningType.initialState;
  late DailyWord _dailyWord;
  List<LetterField> _lettersList = List<LetterField>.filled(
      30,
      LetterField.emptyState()
  );

  @override
  void initState() {
    super.initState();
    _setDisposes();
    _fetchDailyWord();
    _checkPlayerHistory();
    _updateRowBorderColor();
  }

  void _fetchDailyWord() async {
    await _viewModel.fetchDailyWord();
    _updateRowBorderColor();
  }

  void _setDisposes() {
    _setDailyWordDispose();
    _setValidWordsDispose();
    _setCurrentIndexDispose();
    _setWarningBannerDispose();
    _setPlayedLettersListDispose();
    _setIsGuessingTriesFinishedDispose();
    _setIsFirstTimeDispose();
    _setPlayerHistoryDispose();
  }

  void _setDailyWordDispose() {
    reaction((_) => _viewModel.dailyWord, (dailyWord) {
      if (dailyWord != null && dailyWord is DailyWord) {
        _dailyWord = dailyWord;
      }
    });
  }

  void _setValidWordsDispose() {
    reaction((_) => _viewModel.validWords, (validWords) {
      if (validWords != null && validWords is Map<String, List<String>>) {
        _validWords = validWords['validWords'] as List<String>;
        _validWordsNoDiactrics = validWords['validWordsNoDiactrics']
          as List<String>;
      }
    });
  }

  void _setCurrentIndexDispose() {
    reaction((_) => _viewModel.lastIndex, (currentIndex) {
      if (currentIndex != null && currentIndex is int) {
        _currentIndex = currentIndex;
        _minIndex = currentIndex;
        _maxIndex = currentIndex + 4;

        _updateRowBorderColor();
      }
    });
  }

  void _setPlayedLettersListDispose() {
    reaction((_) => _viewModel.playedLettersList, (playedLettersList) {
      if (playedLettersList != null && playedLettersList is List<LetterField>) {
        _lettersList = playedLettersList;
      }
    });
  }

  void _setWarningBannerDispose() {
    reaction((_) => _viewModel.warningType, (warningType) {
      if (warningType != null && warningType is WarningType) {
        _handleWarningBanner(warningType);
      }
    });
  }

  void _setIsGuessingTriesFinishedDispose() {
    reaction((_) => _viewModel.isGuessingTriesFinished, (isGuessingTriesFinished) {
      if (isGuessingTriesFinished != null &&
          isGuessingTriesFinished is bool &&
          isGuessingTriesFinished) {
        //setState(() {});
      }
    });
  }

  void _setIsFirstTimeDispose() {
    reaction((_) => _viewModel.isFirstTime, (isFirstTime) {
      if (isFirstTime != null &&
          isFirstTime is bool &&
          isFirstTime) {
        _showTutorialDialog();
      }
    });
  }

  void _setPlayerHistoryDispose() {
    reaction((_) => _viewModel.playerHistory, (playerHistory) {
      if (playerHistory != null && playerHistory is PlayerHistoryData) {
        this.playerHistory = playerHistory;
      }
    });
  }

  void _updateRowBorderColor() {
    for (int i = 0; i < _lettersList.length; i++) {
      if (i >= _minIndex && i <= _maxIndex) {
        _lettersList[i] = LetterField.changeBorderColor(
            "",
            AppColors.selectedRowLetterBoxBackground,
            AppColors.selectedRowBorder
        );
      } else {
        _lettersList[i] = LetterField(
            letter: _lettersList[i].letter,
            background: _lettersList[i].background
        );
      }
    }
  }

  void _checkPlayerHistory() {
    _viewModel.checkPlayerHistory();
  }

  void _handleTappedKey(String key) {
    if (_viewModel.isGuessingTriesFinished) return;

    final lastIndex = _lettersList.length - 1;

    setState(() {
      switch(key.toLowerCase()) {
        case "back":
          if (!_isWordGuessed) {
            if (_currentIndex > _minIndex && _currentIndex < _maxIndex) {
              _currentIndex--;
            }

            if (_currentIndex == _maxIndex &&
                _lettersList[_currentIndex].letter.isEmpty) {
              _currentIndex--;
            }

            _lettersList[_currentIndex] = LetterField.changeBorderColor(
                "",
                AppColors.selectedRowLetterBoxBackground,
                AppColors.selectedRowBorder
            );
          }

          break;

        case "enter":
          if (_maxIndex <= lastIndex) {
            if (_viewModel.isValidWord(_getTyppedWord())) {
              _checkWord();
              if (!_isWordGuessed) {
                if (_maxIndex < lastIndex) {
                  _minIndex += widget.wordLength;
                  _maxIndex += widget.wordLength;
                  _currentIndex = _minIndex;
                  tries++;
                  _updateRowBorderColor();
                } else {
                  _setDailyGuessingTriesFinished();
                }
              } else {
                _setDailyGuessingTriesFinished();
              }
              SharedPreferencesHelper.saveStringPrefs(
                  SharedPreferencesKeys.triesList,
                  jsonEncode(_lettersList)
              );
              SharedPreferencesHelper.saveIntPrefs(
                  SharedPreferencesKeys.currentIndex,
                  _currentIndex
              );
            }
          }
          break;

        default:
          if (_currentIndex < _maxIndex) {
            _lettersList[_currentIndex] = LetterField.changeBorderColor(
                key,
                AppColors.selectedRowLetterBoxBackground,
                AppColors.selectedRowBorder
            );
            _currentIndex++;
          } else {
            if (_lettersList[_currentIndex].letter.isEmpty) {
              _lettersList[_currentIndex] = LetterField.changeBorderColor(
                  key,
                  AppColors.selectedRowLetterBoxBackground,
                  AppColors.selectedRowBorder
              );
            }
          }
      }
    });
  }

  String _getTyppedWord() {
    String word = "";

    for (int i = _minIndex; i <= _maxIndex; i++) {
      word += _lettersList[i].letter;
    }

    return word;
  }

  void _handleWarningBanner(WarningType warningType) {
    switch(warningType) {
      case WarningType.incompleteWord:
      case WarningType.invalidWord:
        _shakeTyppedWord();
        break;
      default:
    }
  }

  void _shakeTyppedWord() {
    for (int i = _minIndex; i <=  _maxIndex; i++) {
      _lettersList[i].key.currentState?.shake();
    }
  }

  void _showWarningBanner(WarningType warningType) {
    _warningType = warningType;
    _isWarningBannerVisible = true;

    if (_warningType != WarningType.wrongWord) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isWarningBannerVisible = false;
        });
      });
    }
  }

  void _showHistoryBottomSheet() {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context)
    {
      return PlayerHistory(historyData: playerHistory);
    });
  }
  void _setDailyGuessingTriesFinished() {
    if (_isWordGuessed) {
      _showWarningBanner(WarningType.rightWord);
      playerHistory.updateWins();
      playerHistory.updateTries(tries);
      playerHistory.updateCurrentSequence();
      playerHistory.checkBestSequence();
    } else {
      _showWarningBanner(WarningType.wrongWord);
      playerHistory.updateDefeats();
      playerHistory.resetCurrentSequence();
    }

    setState(() {
      _isGuessingTriesFinished = true;
    });

    _saveWordIsMissed(!_isWordGuessed);
    _showHistoryBottomSheet();

    SharedPreferencesHelper.saveStringPrefs(
      SharedPreferencesKeys.playerHistory,
      jsonEncode(playerHistory)
    );

    SharedPreferencesHelper.saveBooleanPrefs(
      SharedPreferencesKeys.dailyGuessingFinished,
      true
    );
  }

  void _saveWordIsMissed(bool isWordMissed) async {
    await SharedPreferencesHelper.saveBooleanPrefs(
        SharedPreferencesKeys.wordMissed,
        isWordMissed
    );
  }

  void _checkWord() {
    var dailyWord = _viewModel.dailyWord.dailyWord;

    String lowerGuessingWord = removeDiacritics(_dailyWord.dailyWord.toLowerCase());
    String lowerTyppedWord = _getTyppedWord().toLowerCase();
    int typpedIndex = _minIndex;
    int wordDiactricIndex = _validWordsNoDiactrics.indexOf(lowerTyppedWord);

    for (int i = 0; i < _dailyWord.dailyWord.length; i++) {
      String typpedLetter = lowerTyppedWord[i];
      String diactricLetter = _validWords[wordDiactricIndex][i].toUpperCase();
      if (lowerGuessingWord[i] == typpedLetter) {
        _setRightPositionLetterBackground(diactricLetter, typpedIndex);
      }

      if (!lowerGuessingWord.contains(typpedLetter)) {
        _setNoLetterBackground(diactricLetter, typpedIndex);
      }

      if (lowerGuessingWord.contains(typpedLetter) && lowerGuessingWord[i] != typpedLetter) {
        int typpedMatches = typpedLetter.allMatches(_dailyWord.dailyWord).length;
        int typpedAmount = typpedLetter.allMatches(lowerTyppedWord).length;

        if (typpedAmount == 1) {
          _setWrongPositionLetterBackground(diactricLetter, typpedIndex);
        } else {
          for (int j = 0; j < _dailyWord.dailyWord.length; j++) {
            if (lowerTyppedWord[j] != typpedLetter) continue;
            if (lowerGuessingWord[j] == lowerTyppedWord[j]) {
              typpedAmount--;
              if (typpedAmount == typpedMatches) {
                _setNoLetterBackground(diactricLetter, typpedIndex);
                typpedAmount = 0;
                break;
              }
            }
          }
          if (typpedAmount > 0) {
            _setWrongPositionLetterBackground(diactricLetter, typpedIndex);
          }
        }
      }

      typpedIndex++;
    }

    bool allLettersCorrect = true;
    for (int i = _minIndex; i <= _maxIndex; i++) {
      if (_lettersList[i].background != AppColors.rightLetterPosition) {
        allLettersCorrect = false;
        break;
      }
    }

    _isWordGuessed = allLettersCorrect;

    if (_isWordGuessed) {
      _setOnlyRightKeysBackground();
    }

    SharedPreferencesHelper.saveStringPrefs(
      SharedPreferencesKeys.typedKeys,
      jsonEncode(_viewModel.keyboardKeysList)
    );
  }

  void _setOnlyRightKeysBackground() {
    for (int i = 0; i < _viewModel.keyboardKeysList.length; i++) {
      for (int j = 0; j < _viewModel.keyboardKeysList[i].length; j++) {
        if (_viewModel.keyboardKeysList[i][j].background != AppColors.rightLetterPosition) {
          _viewModel.keyboardKeysList[i][j] = KeyboardKey.changeBackground(
              _viewModel.keyboardKeysList[i][j].letter,
              null
          );
        }
      }
    }
  }

  void _setRightPositionLetterBackground(String letter, int index) {
    _lettersList[index] = LetterField(
        letter: letter,
        background: AppColors.rightLetterPosition
    );
    _setKeyboardKeyBackground(letter, KeyStatus.rightPosition);
  }

  void _setWrongPositionLetterBackground(String letter, int index) {
    _lettersList[index] = LetterField(
        letter: letter,
        background: AppColors.wrongLetterPosition
    );
    _setKeyboardKeyBackground(letter, KeyStatus.wrongPosition);
  }

  void _setNoLetterBackground(String letter, int index) {
    _lettersList[index] = LetterField(
        letter: letter,
        background: AppColors.noLetter
    );
    _setKeyboardKeyBackground(letter, KeyStatus.wrongLetter);
  }

  void _setKeyboardKeyBackground(String letter, KeyStatus keyStatus) {
    for (int i = 0; i < _viewModel.keyboardKeysList.length; i++) {
      try {
        String noDiacriticsLetter = removeDiacritics(letter.toUpperCase());

        KeyboardKey keyboardKey(String letter) => _viewModel.keyboardKeysList[i].firstWhere((key) =>
          key.letter == noDiacriticsLetter.toUpperCase());

        KeyboardKey key = keyboardKey(letter);
        bool changeBackground = false;
        int? background;

        switch(keyStatus) {
          case KeyStatus.rightPosition:
            changeBackground = true;
            background = AppColors.rightLetterPosition;
            break;
          case KeyStatus.wrongPosition:
            background = AppColors.wrongLetterPosition;

            if (key.background == AppColors.rightLetterPosition) {
              changeBackground = false;
            } else {
              changeBackground = true;
            }
            break;
          case KeyStatus.wrongLetter:
            background = AppColors.noLetter;

            if (key.background == AppColors.rightLetterPosition ||
                key.background == AppColors.wrongLetterPosition) {
              changeBackground = false;
            } else {
              changeBackground = true;
            }
            break;
        }

        if (changeBackground) {
          List<KeyboardKey> row = _viewModel.keyboardKeysList[i];
          int keyIndex = row.indexOf(key);

          _viewModel.keyboardKeysList[i][keyIndex] = KeyboardKey.changeBackground(
              noDiacriticsLetter,
              background
          );
        }

        break;
      } catch(e) {
        continue;
      }
    }
  }

  void _showTutorialDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (builderContext, __, ___) {
        tutorialDialogContext = builderContext;
        return TutorialDialog(
          onClosePressed: _dismissTutorialDialog,
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void _dismissTutorialDialog() {
    if (tutorialDialogContext != null) {
      Navigator.pop(tutorialDialogContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.homeBackground),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Observer(
              builder: (_) {
                return _viewModel.isLoading ? const LoadingLottie() : _viewModel.isError ?
                ErrorScreen(onTryAgain: _fetchDailyWord) :
                Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BorderIconButton(
                            icon: Icons.history,
                            onPressed: _showHistoryBottomSheet,
                          ),
                          Text(
                            "FIVE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(AppColors.defaultTextColor),
                                fontSize: 50,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          BorderIconButton(
                            icon: Icons.question_mark,
                            onPressed: _showTutorialDialog,
                          )
                        ],
                      ),
                      Visibility(
                          visible: _viewModel.isGuessingTriesFinished,
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              CountDownTimer(
                                timeRemaining: _viewModel.dailyWord.nextWordRemainingTime,
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            WarningBanner(
                              warning: _viewModel.warningType,
                              showBanner: _viewModel.isWarningVisible,
                              rightWord: _viewModel.dailyWord.dailyWord,
                            ),
                            const SizedBox(height: 30),
                            Flexible(
                                child: GridLetterBoxes(
                                  wordLength: 5,
                                  attemptsAllowed: 6,
                                  currentIndex: _currentIndex,
                                  lettersList: _lettersList,
                                )
                            ),
                            const SizedBox(height: 50),
                            Keyboard(
                              onKeyTapped: _handleTappedKey,
                              keysRows: _viewModel.keyboardKeysList,
                            )
                          ],
                        )
                    )
                  ]
                );
              },
            )
          ),
        )
      )
    );
  }
}
