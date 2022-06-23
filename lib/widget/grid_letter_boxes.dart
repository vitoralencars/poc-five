import 'package:flutter/material.dart';
import 'package:five/model/letter_field.dart';
import 'package:five/widget/letter_box.dart';
import '../util/constant/app_colors.dart';

class GridLetterBoxes extends StatefulWidget {
  const GridLetterBoxes({
    Key? key,
    this.hideLetters = false,
    required this.wordLength,
    required this.lettersList
  }) : super(key: key);

  final int wordLength;
  final List<LetterField> lettersList;
  final bool hideLetters;

  @override
  State<GridLetterBoxes> createState() => _GridLetterBoxesState();
}

class _GridLetterBoxesState extends State<GridLetterBoxes> {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(AppColors.homeBackground),
      child: GridView.count(
        padding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
        shrinkWrap: true,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: widget.wordLength,
        childAspectRatio: 1,
        children: widget.lettersList.map((letterField) {
          return LetterBox(
            hideLetter: widget.hideLetters,
            letterField: letterField,
            index: widget.lettersList.indexOf(letterField)
          );
        }).toList()
      )
    );
  }
}
