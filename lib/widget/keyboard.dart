import 'package:flutter/material.dart';
import 'package:pocs_flutter/model/keyboard_key.dart';
import 'package:pocs_flutter/util/app_colors.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({
    Key? key,
    required this.onKeyTapped,
    required this.keysRows
  }) : super(key: key);

  final ValueChanged<String> onKeyTapped;
  final List<List<KeyboardKey>> keysRows;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    for (List<KeyboardKey> row in widget.keysRows) {
      rows.add(_buildRowList(row));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows
    );
  }

  Widget _buildRowList(List<KeyboardKey> keys) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 50, minHeight: 50),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return _buildKey(keys[index]);
        }
      )
    );
  }

  Widget _buildKey(KeyboardKey key) {
    switch(key.letter.toLowerCase()) {
      case "back":
        return _buildBackspaceKey();
      case "enter":
        return _buildEnterKey();
      default:
        return _buildLetterKey(key);
    }
  }

  Widget _buildBackspaceKey() {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Color(AppColors.keyboardDefaultBackground),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        alignment: Alignment.center,
        icon: const Icon(Icons.backspace_outlined),
        color: Colors.white,
        onPressed: () {
          widget.onKeyTapped("back");
        },
      ),
    );
  }

  Widget _buildEnterKey() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        widget.onKeyTapped("Enter");
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Color(AppColors.keyboardDefaultBackground),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Enter",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          )
        ),
      ),
    );
  }

  Widget _buildLetterKey(KeyboardKey key) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        widget.onKeyTapped(key.letter);
      },
      child: Container(
        width: 30,
        height: 40,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: key.background != null ?
            Color(key.background!) : Color(AppColors.keyboardDefaultBackground),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          key.letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18
          )
        ),
      ),
    );
  }
}
