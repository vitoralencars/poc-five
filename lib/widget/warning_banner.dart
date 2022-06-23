import 'package:flutter/material.dart';
import '../model/warning.dart';
import '../util/constant/app_colors.dart';

class WarningBanner extends StatelessWidget {
  const WarningBanner({
    Key? key,
    required this.warning,
    required this.rightWord,
    required this.onSharedButtonPressed
  }) : super(key: key);

  final WarningType? warning;
  final String rightWord;
  final VoidCallback onSharedButtonPressed;

  @override
  Widget build(BuildContext context) {
    Warning warningBanner = _getWarning(rightWord);

    return Center(
      child: AnimatedOpacity(
        opacity: warning != WarningType.hiddenState ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: warningBanner.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                warningBanner.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
              Visibility(
                visible: _isGuessingAttemptsFinished(warning),
                child: IconButton(
                  onPressed: onSharedButtonPressed,
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.share),
                  color: Colors.white,
                )
              )
            ],
          )
        ),
      ),
    );
  }

  bool _isGuessingAttemptsFinished(WarningType? warning) {
    return warning == WarningType.rightWord || warning == WarningType.wrongWord;
  }

  Warning _getWarning(String rightWord) {
    switch(warning) {
      case WarningType.invalidWord:
        return Warning("Palavra inválida", Color(AppColors.invalidWordWarning));
      case WarningType.incompleteWord:
        return Warning("Palavra incompleta", Color(AppColors.incompleteWordWarning));
      case WarningType.rightWord:
        return Warning("Parabéns, você acertou!", Color(AppColors.rightWordWarning));
      case WarningType.wrongWord:
        return Warning("Que pena! A palavra correta é \"$rightWord\".", Color(AppColors.selectedRowBorder));
      default:
        return Warning("", Colors.transparent);
    }
  }

}

enum WarningType {
  hiddenState,
  invalidWord,
  incompleteWord,
  rightWord,
  wrongWord
}
