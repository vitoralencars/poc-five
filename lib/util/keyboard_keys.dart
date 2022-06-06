import 'package:five/model/keyboard_key.dart';
import 'package:five/util/app_colors.dart';

class KeyboardKeys {
  static final firstRow = ["Q","W","E","R","T","Y","U","I","O","P"];
  static final secondRow = ["A","S","D","F","G","H","J","K","L", "back"];
  static final thirdRow = ["Z","X","C","V","B","N","M","Enter"];

  static List<KeyboardKey> getRowList(List<String> row) {
    List<KeyboardKey> rowList = [];
    for (String letter in row) {
      rowList.add(KeyboardKey(
        letter: letter
      ));
    }

    return rowList;
  }

  static List<List<KeyboardKey>> getKeysList() {
    List<List<KeyboardKey>> keysList = [];
    keysList.add(getRowList(firstRow));
    keysList.add(getRowList(secondRow));
    keysList.add(getRowList(thirdRow));

    return keysList;
  }

}

enum KeyStatus {
  rightPosition,
  wrongPosition,
  wrongLetter
}