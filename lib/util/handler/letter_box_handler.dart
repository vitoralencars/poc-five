import 'package:pocs_flutter/model/letter_field.dart';
import 'package:pocs_flutter/util/app_colors.dart';
import 'package:pocs_flutter/util/handler/keyboard_key_handler.dart';
import '../../model/keyboard_key.dart';
import '../keyboard_keys.dart';

class LetterBoxHandler {

  static setOnlyRightKeysBackground(List<List<KeyboardKey>> keyboardKeys) {
    for (int i = 0; i < keyboardKeys.length; i++) {
      for (int j = 0; j < keyboardKeys[i].length; j++) {
        if (keyboardKeys[i][j].background != AppColors.rightLetterPosition) {
          keyboardKeys[i][j] = KeyboardKey.changeBackground(
            keyboardKeys[i][j].letter,
            null
          );
        }
      }
    }
  }

  static setRightPositionLetterBackground(
    List<List<KeyboardKey>> keyboardKeys,
    List<LetterField> lettersList,
    String letter,
    int index
  ) {
    lettersList[index] = LetterField(
        letter: letter,
        background: AppColors.rightLetterPosition
    );
    KeyboardKeyHandler.setKeyboardKeyBackground(
        keyboardKeys,
        letter,
        KeyStatus.rightPosition
    );
  }

  static setWrongPositionLetterBackground(
    List<List<KeyboardKey>> keyboardKeys,
    List<LetterField> lettersList,
    String letter,
    int index
  ) {
    lettersList[index] = LetterField(
        letter: letter,
        background: AppColors.wrongLetterPosition
    );
    KeyboardKeyHandler.setKeyboardKeyBackground(
      keyboardKeys,
      letter,
      KeyStatus.wrongPosition
    );
  }

  static setNoLetterBackground(
    List<List<KeyboardKey>> keyboardKeys,
    List<LetterField> lettersList,
    String letter,
    int index
  ) {
    lettersList[index] = LetterField(
      letter: letter,
      background: AppColors.noLetter
    );
    KeyboardKeyHandler.setKeyboardKeyBackground(
      keyboardKeys,
      letter,
      KeyStatus.wrongLetter
    );
  }
}
