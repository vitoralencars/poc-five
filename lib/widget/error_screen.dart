import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:five/util/app_colors.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key? key,
    required this.onTryAgain
  }) : super(key: key);

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/error_screen_illustration.svg',
                width: 200,
                height: 180,
              ),
              const SizedBox(height: 30),
              Text(
                "Ops!\nAlgo deu errado ao tentar carregar a palavra diária!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(AppColors.defaultTextColor),
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: (){
                onTryAgain();
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                padding: const EdgeInsets.all(16),
                primary: Colors.white,
                backgroundColor: Color(AppColors.tryAgainButtonBackground)
              ),
              child: Text(
                "Tentar novamente",
                style: TextStyle(
                  color: Color(AppColors.defaultTextColor),
                  fontSize: 18
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
