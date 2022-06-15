import 'package:flutter/material.dart';
import 'package:five/model/letter_field.dart';
import 'package:five/widget/letter_box.dart';
import '../util/constant/app_colors.dart';

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({
    Key? key,
    required this.onClosePressed
  }) : super(key: key);

  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.80
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Color(AppColors.homeBackground),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _buildContentChildren(),
                  ),
                )
              ),
            )
          ],
        ),
      )
    );
  }

  List<Widget> _buildContentChildren() {
    List<Widget> widgetList = [];

    widgetList.add(Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.close),
        color: Color(AppColors.defaultTextColor),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(4),
        splashRadius: 24,
        onPressed: onClosePressed
      ),
    ));

    widgetList.addAll(_buildExplanationContent());

    return widgetList;
  }

  List<Widget> _buildExplanationContent() {
    return [
      _buildTextExplanationTitle("Como jogar?"),
      const SizedBox(height: 10),
      _buildTextExplanation("O objetivo é acertar a palavra diária em até 6 tentativas. A palavra sempre irá conter 5 letras."),
      const SizedBox(height: 10),
      _buildRichTextExplanation([
        _buildNormalTextSpan("Suponhamos que a palavra diária seja "),
        _buildHighlightedText(" VALOR ", AppColors.rightLetterPosition),
        _buildNormalTextSpan(" e a palavra utilizada para tentar acertar seja "),
        _buildHighlightedText(" CANTO ", AppColors.noLetter),
        _buildNormalTextSpan("."),
      ]),
      const SizedBox(height: 16),
      _buildTextExplanationTitle("O resultado será o seguinte:"),
      const SizedBox(height: 8),
      _buildExampleLettersRow(),
      const SizedBox(height: 16),
      _buildTextExplanationTitle("Isto significa que:"),
      const SizedBox(height: 4),
      _buildRichTextExplanation([
        _buildNormalTextSpan("- a letra "),
        _buildHighlightedText(" A ", AppColors.rightLetterPosition),
        _buildNormalTextSpan(
          " existe na palavra diária e está posicionada corretamente;"
        ),
      ]),
      _buildRichTextExplanation([
        _buildNormalTextSpan("- a letra "),
        _buildHighlightedText(" O ", AppColors.wrongLetterPosition),
        _buildNormalTextSpan(
          " existe na palavra diária, porém está fora de posição;"
        ),
      ]),
      _buildRichTextExplanation([
        _buildNormalTextSpan("- as letras "),
        _buildHighlightedText(" C ", AppColors.noLetter),
        _buildNormalTextSpan(" , "),
        _buildHighlightedText(" N ", AppColors.noLetter),
        _buildNormalTextSpan(" e "),
        _buildHighlightedText(" T ", AppColors.noLetter),
        _buildNormalTextSpan(" não existem na palavra diária."),
      ]),
      const SizedBox(height: 10),
      _buildTextExplanationTitle("Observações:"),
      const SizedBox(height: 4),
      _buildTextExplanation(
        "- não serão aceitas palavras inexistentes;\n- acentos são "
        "preenchidos automaticamente ao finalizar a tentativa;\n- "
        "letras podem se repetir;\n- nomes próprios não são considerados "
        "palavras."
      ),
    ];
  }

  Widget _buildTextExplanationTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(AppColors.defaultTextColor)
      ),
    );
  }

  Widget _buildTextExplanation(String explanation) {
    return Text(
      explanation,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 16,
        color: Color(AppColors.defaultTextColor)
      ),
    );
  }

  Widget _buildRichTextExplanation(List<TextSpan> textList) {
    return RichText(text: TextSpan(
      children: textList
    ));
  }

  TextSpan _buildNormalTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 16,
        color: Color(AppColors.defaultTextColor)
      ),
    );
  }

  TextSpan _buildHighlightedText(String text, [int? highlightColor]) {
    var backgroundColor = Color(highlightColor ?? AppColors.transparent);

    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(AppColors.defaultTextColor),
        backgroundColor: backgroundColor
      )
    );
  }

  Widget _buildExampleLettersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLetterBox("C", AppColors.noLetter, 0),
        _buildLetterBox("A", AppColors.rightLetterPosition, 1),
        _buildLetterBox("N", AppColors.noLetter, 2),
        _buildLetterBox("T", AppColors.noLetter, 3),
        _buildLetterBox("O", AppColors.wrongLetterPosition, 4),
      ],
    );
  }

  Widget _buildLetterBox(String letter, int background, int index) {
    return SizedBox(
      height: 50,
      width: 50,
      child: LetterBox(
        letterField: LetterField(
          letter: letter,
          background: background
        ),
        index: index,
      ),
    );
  }
}
