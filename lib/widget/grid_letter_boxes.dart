import 'package:flutter/material.dart';
import 'package:pocs_flutter/model/letter_field.dart';
import 'package:pocs_flutter/widget/letter_box.dart';
import 'package:pocs_flutter/util/app_colors.dart';

class GridLetterBoxes extends StatefulWidget {
  const GridLetterBoxes({
    Key? key,
    required this.wordLength,
    required this.attemptsAllowed,
    required this.currentIndex,
    required this.lettersList
  }) : super(key: key);

  final int wordLength;
  final int attemptsAllowed;
  final int currentIndex;
  final List<LetterField> lettersList;

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
          return LetterBox(letterField: letterField);
        }).toList()
      )
    );
  }
}
