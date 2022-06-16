import 'package:firebase_core/firebase_core.dart';
import 'package:five/util/constant/analytics_events.dart';
import 'package:five/util/constant/app_colors.dart';
import 'package:five/util/handler/analytics_event_handler.dart';
import 'package:five/widget/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:five/store/main_store.dart';
import 'package:five/store/player_history_store.dart';
import 'package:five/util/handler/word_handler.dart';
import 'package:five/widget/countdown_timer.dart';
import 'package:five/widget/error_screen.dart';
import 'package:five/widget/grid_letter_boxes.dart';
import 'package:five/widget/keyboard.dart';
import 'package:five/widget/loading_lottie.dart';
import 'package:five/widget/player_history.dart';
import 'package:five/widget/tutorial_dialog.dart';
import 'package:five/widget/warning_banner.dart';
import 'di/service_locator.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await WordHandler.setupValidWords();
  setupLocator();
  runApp(const FiveApp());
}

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class FiveApp extends StatelessWidget {
  const FiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Color(AppColors.homeBackground)
      ),
      home: const MainPage()
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _mainStore = serviceLocator<MainStore>();
  final _playerHistoryStore = serviceLocator<PlayerHistoryStore>();
  final List<ReactionDisposer> _disposers = [];

  BuildContext? tutorialDialogContext;

  @override
  void initState() {
    super.initState();
    _setDisposers();
    _fetchDailyWord();
    _updateRowBorderColor();
  }

  @override
  void dispose(){
    for (var disposer in _disposers) {
      disposer();
    }
    super.dispose();
  }

  void _fetchDailyWord() async {
    await _mainStore.fetchDailyWord();
  }

  void _updateRowBorderColor() {
    _mainStore.updateRowBorderColor();
  }

  void _setDisposers() {
    _setIsGuessingAttemptsFinishedDispose();
    _setWarningBannerDispose();
    _setIsFirstTimeDispose();
  }

  void _setIsGuessingAttemptsFinishedDispose() {
    _disposers.add(reaction((_) => _mainStore.isGuessingAttemptsFinished,
      (isGuessingAttemptsFinished) {
        if (isGuessingAttemptsFinished != null &&
            isGuessingAttemptsFinished is bool &&
            isGuessingAttemptsFinished
        ) {
          _handleFinishedGuessingAttempts();
        }
      }
    ));
  }

  void _setWarningBannerDispose() {
    _disposers.add(reaction((_) => _mainStore.warningType, (warningType) {
      if (warningType != null && warningType is WarningType) {
        _handleWarningBanner(warningType);
      }
    }));
  }

  void _setIsFirstTimeDispose() {
    _disposers.add(reaction((_) => _mainStore.isFirstTime, (isFirstTime) {
      if (isFirstTime != null &&
          isFirstTime is bool &&
          isFirstTime) {
        _showTutorialDialog();
      }
    }));
  }

  void _handleTappedKey(String key) {
    if (
      _mainStore.isGuessingAttemptsFinished ||
      _mainStore.isFinishedDailyGame
    ) return;

    switch(key.toLowerCase()) {
      case "back":
        _mainStore.eraseLetter();
        break;

      case "enter":
        _mainStore.enterWord();
        break;

      default:
        _mainStore.setLetter(key);
    }
  }

  void _handleWarningBanner(WarningType warningType) {
    switch(warningType) {
      case WarningType.incompleteWord:
      case WarningType.invalidWord:
        _mainStore.shakeInvalidWord();
        break;
      default:
    }
  }

  void _onHistoryButtonPressed() {
    AnalyticsEventsHandler.logEvent(AnalyticsEvents.historyPressed);
    _showHistoryBottomSheet();
  }

  void _showHistoryBottomSheet() {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context)
    {
      return const PlayerHistory();
    });
  }

  void _handleFinishedGuessingAttempts() async {
    var attempts = _mainStore.isWordGuessed ? _mainStore.attempts : null;

    await _playerHistoryStore.updatePlayerHistory(attempts);

    Future.delayed(const Duration(seconds: 2), () {
      _showHistoryBottomSheet();
    });
  }

  void _onTutorialButtonPressed() {
    AnalyticsEventsHandler.logEvent(AnalyticsEvents.tutorialPressed);
    _showTutorialDialog();
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
                return _mainStore.isLoading ? const LoadingScreen() :
                  _mainStore.isError ?
                  ErrorScreen(onTryAgain: _fetchDailyWord) :
                  Column(
                      children: <Widget>[
                        ScreenHeader(
                          onHistoryPressed: _onHistoryButtonPressed,
                          onInstructionsPressed: _onTutorialButtonPressed
                        ),
                        Visibility(
                            visible: _mainStore.isFinishedDailyGame,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                CountDownTimer(
                                  timeRemaining: _mainStore.dailyWord
                                      .nextWordRemainingTime,
                                ),
                              ],
                            )
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              WarningBanner(
                                warning: _mainStore.warningType,
                                rightWord: _mainStore.dailyWord.dailyWord,
                              ),
                              const SizedBox(height: 30),
                              Flexible(
                                  child: GridLetterBoxes(
                                    wordLength: 5,
                                    lettersList: _mainStore.playedLetters,
                                  )
                              ),
                              const SizedBox(height: 10),
                              Keyboard(
                                onKeyTapped: _handleTappedKey,
                                keysRows: _mainStore.keyboardKeysList,
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
