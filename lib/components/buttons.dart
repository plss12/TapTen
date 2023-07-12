import 'package:flutter/material.dart';
import '/const/colors.dart';
//import 'dart:async';

class Buttons {
  void _increaseTries(int tries, void Function(int) updateTries) {
    updateTries(tries + 5);
  }

  void _decreaseTries(int tries, void Function(int) updateTries) {
    updateTries(tries - 1);
  }

  Container moreTries(int tries, void Function(int) updateTries) => Container(
      //padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      decoration: BoxDecoration(
          color: ColorsData.boxColor, borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: ColorsData.coin,
          color: ColorsData.boxNumberColor,
          tooltip: 'Más intentos',
          onPressed: () => _increaseTries(tries, updateTries),
        )
      ]));

  Container lessTries(int tries, void Function(int) updateTries) => Container(
      //padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      decoration: BoxDecoration(
          color: ColorsData.boxColor, borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: ColorsData.topIcon,
          color: ColorsData.boxNumberColor,
          tooltip: 'Mejores puntuaciones',
          onPressed: () => _decreaseTries(tries, updateTries),
        )
      ]));
}
