import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:five/model/letter_field.dart';
import 'package:five/util/handler/letter_box_handler.dart';
import '../../model/keyboard_key.dart';
import '../constant/app_colors.dart';

class WordHandler {

  static List<String> _validWords = [];
  static List<String> _validWordsNoDiactrics = [];

  static Future<void> setupValidWords() async {
    _validWords = await _fetchValidWords('assets/validWords.txt');
    _validWordsNoDiactrics = await _fetchValidWords(
        'assets/validWordsNoDiactrics.txt'
    );
  }

  static Future<bool> isWordCorrect(
    List<LetterField> letters,
    List<List<KeyboardKey>> keyboardKeys,
    String typpedWord,
    String dailyWord,
    int firstIndex
  ) async {

    String lowerGuessingWord = removeDiacritics(dailyWord.toLowerCase());
    String lowerTyppedWord = typpedWord.toLowerCase();
    int typpedIndex = firstIndex;
    int wordDiactricIndex = _validWordsNoDiactrics.indexOf(lowerTyppedWord);

    for (int i = 0; i < dailyWord.length; i++) {
      String typpedLetter = lowerTyppedWord[i];
      String diactricLetter = _validWords[wordDiactricIndex][i].toUpperCase();

      if (lowerGuessingWord[i] == typpedLetter) {
        LetterBoxHandler.setRightPositionLetterBackground(
          keyboardKeys,
          letters,
          diactricLetter,
          typpedIndex
        );
      }

      if (!lowerGuessingWord.contains(typpedLetter)) {
        LetterBoxHandler.setNoLetterBackground(
          keyboardKeys,
          letters,
          diactricLetter,
          typpedIndex
        );
      }

      if (lowerGuessingWord.contains(typpedLetter) && lowerGuessingWord[i] != typpedLetter) {
        int typpedMatches = typpedLetter.allMatches(dailyWord).length;
        int typpedAmount = typpedLetter.allMatches(lowerTyppedWord).length;

        if (typpedAmount == 1) {
          LetterBoxHandler.setWrongPositionLetterBackground(
            keyboardKeys,
            letters,
            diactricLetter,
            typpedIndex
          );
        } else {
          for (int j = 0; j < dailyWord.length; j++) {
            if (lowerTyppedWord[j] != typpedLetter) continue;
            if (lowerGuessingWord[j] == lowerTyppedWord[j]) {
              typpedAmount--;
              if (typpedAmount == typpedMatches) {
                LetterBoxHandler.setNoLetterBackground(
                  keyboardKeys,
                  letters,
                  diactricLetter,
                  typpedIndex
                );
                typpedAmount = 0;
                break;
              }
            }
          }
          if (typpedAmount > 0) {
            LetterBoxHandler.setWrongPositionLetterBackground(
              keyboardKeys,
              letters,
              diactricLetter,
              typpedIndex
            );
          }
        }
      }

      typpedIndex++;
    }

    bool allLettersCorrect = true;
    var maxIndex = firstIndex + 4;
    for (int i = firstIndex; i <= maxIndex; i++) {
      if (letters[i].background != AppColors.rightLetterPosition) {
        allLettersCorrect = false;
        break;
      }
    }

    if (allLettersCorrect) {
      LetterBoxHandler.setOnlyRightKeysBackground(keyboardKeys);
    }

    return allLettersCorrect;
  }

  static WordValidation wordValidationResult(String typpedWord) {
    if (typpedWord.length < 5) {
      return WordValidation.incompleteWord;
    }

    if (!_validWords.contains(typpedWord.toLowerCase())) {
      return WordValidation.invalidWord;
    }

    return WordValidation.validWord;
  }

  static Future<List<String>> _fetchValidWords(String filePath) async {
    String wordsFile = await rootBundle.loadString(filePath);
    return wordsFile.split("\n").toList();
  }
}

enum WordValidation{
  validWord,
  invalidWord,
  incompleteWord
}
