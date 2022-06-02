import 'package:flutter/material.dart';
import 'package:pocs_flutter/util/app_colors.dart';
import '../model/warning.dart';

class WarningBanner extends StatelessWidget {
  const WarningBanner({
    Key? key,
    required this.warning,
    required this.showBanner,
    required this.rightWord
  }) : super(key: key);

  final WarningType? warning;
  final bool showBanner;
  final String rightWord;

  @override
  Widget build(BuildContext context) {
    Warning warning = _getWarning(rightWord);

    return Center(
      child: AnimatedOpacity(
        opacity: showBanner ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: warning.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            warning.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
          ),
        ),
      ),
    );
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
  initialState,
  invalidWord,
  incompleteWord,
  rightWord,
  wrongWord
}
