import 'package:flutter/material.dart';
import '/const/colors.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key, required this.label, required this.score});

  final String label;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
          color: ColorsData.boxColor, borderRadius: BorderRadius.circular(8.0)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20.0,
            color: ColorsData.boxLetterColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          score,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
        )
      ]),
    );
  }
}
