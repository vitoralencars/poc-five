import 'package:diacritic/diacritic.dart';
import 'package:five/model/keyboard_key.dart';
import '../constant/app_colors.dart';
import '../constant/keyboard_keys.dart';

class KeyboardKeyHandler {

  static setKeyboardKeyBackground(
    List<List<KeyboardKey>> keyboardKeys,
    String letter,
    KeyStatus keyStatus
  ) {
    for (int i = 0; i < keyboardKeys.length; i++) {
      try {
        String noDiacriticsLetter = removeDiacritics(letter.toUpperCase());

        KeyboardKey keyboardKey(String letter) => keyboardKeys[i].firstWhere((key) =>
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
          List<KeyboardKey> row = keyboardKeys[i];
          int keyIndex = row.indexOf(key);

          keyboardKeys[i][keyIndex] = KeyboardKey.changeBackground(
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
}
