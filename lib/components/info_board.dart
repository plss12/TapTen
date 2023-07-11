import 'package:flutter/material.dart';
import '/const/colors.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key, required this.label, required this.score});

  final String label;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: ColorsData.boxColor, borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.0, color: ColorsData.boxLetterColor),
        ),
        Text(
          score,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ]),
    );
  }
}
