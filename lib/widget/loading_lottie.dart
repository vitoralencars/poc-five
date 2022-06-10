import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/five_logo.svg',
            height: 40,
          ),
          const SizedBox(height: 30),
          Lottie.asset(
            'assets/lottie_loading.json',
            height: 150,
            width: 150,
            repeat: true,
            animate: true
          ),
        ],
      )
    );
  }
}
