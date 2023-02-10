import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  // final GestureTapCallback onBodyTap;
  // final GestureTapCallback onCheckTap;
  // final String engWord;
  // final String korWord;
  // final int correctCount;
  final int dailyMoney;

  CustomCard({
    // required this.onBodyTap,
    // required this.onCheckTap,
    // required this.engWord,
    // required this.korWord,
    // required this.correctCount,
    required this.dailyMoney
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // onTap: onBodyTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  dailyMoney.toString(),
                ),
                // Text(
                //   '맞은 횟수 : $correctCount',
                // ),
              ],
            ),
          ),
        ),
        GestureDetector(
          // onTap: onCheckTap,
          child: Icon(
            Icons.check,
          ),
        ),
      ],
    );
  }
}
