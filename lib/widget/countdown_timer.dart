import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocs_flutter/util/app_colors.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key? key,
    required this.timeRemaining
  }) : super(key: key);

  final String timeRemaining;

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {

  late Timer _countDownTimer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = _getDuration();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text(
          "Próxima palavra em:",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(AppColors.defaultTextColor),
            fontSize: 18
          ),
        ),
        Text(
          "${_formatTimeValue(_duration.inHours.remainder(24))}"
          ":${_formatTimeValue(_duration.inMinutes.remainder(60))}"
          ":${_formatTimeValue(_duration.inSeconds.remainder(60))}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(AppColors.defaultTextColor),
            fontWeight: FontWeight.bold,
            fontSize: 22
          ),
        )
      ],
    );
  }

  Duration _getDuration() {
    var splitTimeRemaining = widget.timeRemaining.split(":");
    return Duration(
      hours: int.parse(splitTimeRemaining[0]),
      minutes: int.parse(splitTimeRemaining[1]),
      seconds: int.parse(splitTimeRemaining[2]),
    );
  }

  void _startTimer() {
    _countDownTimer = Timer.periodic(
      const Duration(seconds: 1), (timer) {
        setState(() {
          var seconds = _duration.inSeconds - 1;
          if (seconds < 0) {
            _stopTimer();
          } else {
            _duration = Duration(seconds: _duration.inSeconds - 1);
          }
        });
      }
    );
  }

  void _stopTimer() {
    _countDownTimer.cancel();
  }

  String _formatTimeValue(int value) => value.toString().padLeft(2, '0');
}
