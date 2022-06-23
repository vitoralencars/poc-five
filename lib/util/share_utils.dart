import 'dart:io';

import 'package:five/util/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../model/letter_field.dart';
import '../widget/grid_letter_boxes.dart';

class ShareUtils {

  static void shareResult(
      bool isWordGuessed,
      int attempts,
      List<LetterField> playedLetters
  ) {
    String shareText;
    if (isWordGuessed) {
      shareText = "Joguei Five e acertei a palavra diária em "
          "$attempts/6 tentativas!";
    } else {
      shareText = "Joguei Five e não consegui encontrar a palavra diária. :(";
    }

    ScreenshotController().captureFromWidget(
        _getSharingScreen(playedLetters)).then((result) async {
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/result.png').create();
          file.writeAsBytesSync(result);

          Share.shareFiles([file.path], text: shareText);
        });
  }

  static Widget _getSharingScreen(List<LetterField> playedLetters) {
    return Container(
      color: Color(AppColors.homeBackground),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/five_logo.svg',
            height: 30,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 24),
          GridLetterBoxes(
            hideLetters: true,
            wordLength: 5,
            lettersList: playedLetters,
          )
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/five_logo.svg',
          height: 30,
          alignment: Alignment.center,
        ),
        GridLetterBoxes(
          hideLetters: true,
          wordLength: 5,
          lettersList: playedLetters,
        )
      ],
    );
  }
}
