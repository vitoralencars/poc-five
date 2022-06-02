import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingLottie extends StatefulWidget {
  const LoadingLottie({Key? key}) : super(key: key);

  @override
  State<LoadingLottie> createState() => _LoadingLottieState();
}

class _LoadingLottieState extends State<LoadingLottie> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      alignment: Alignment.center,
      child: Lottie.asset(
        'assets/lottie_loading.json',
        repeat: true,
        animate: true
      ),
    );
  }
}
