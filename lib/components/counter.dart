import 'dart:async';
import 'package:flutter/material.dart';
import '/const/colors.dart';

class Counter extends StatefulWidget {
  const Counter({
    super.key,
    required this.onSaveStatistics,
    required this.onUpdateInformation,
    required this.lastTry,
    required this.bestTry,
  });

  final VoidCallback onSaveStatistics;
  final Function(int, int) onUpdateInformation;
  final int lastTry;
  final ValueNotifier<int> bestTry;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final int _timeTimer = 15;
  int _timer = 15;
  int _lastTry = 0;
  int _bestTry = 0;
  Timer? _timerInstance;
  int _counter = 0;
  bool _start = false;

  @override
  void initState() {
    super.initState();
    _lastTry = widget.lastTry;
    _bestTry = widget.bestTry.value;

    widget.bestTry.addListener(() {
      setState(() {
        _bestTry = widget.bestTry.value;
      });
    });
  }

  void _startTimer() {
    _timerInstance = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _updateTimer();
      });
    });
  }

  void _updateTimer() {
    if (_timer > 0) {
      setState(() {
        _timer--;
      });
    } else {
      _resetCounters();
      widget.onUpdateInformation(_lastTry, _bestTry);
      widget.onSaveStatistics();
      _timerInstance?.cancel();
      _timerInstance = null;
    }
  }

  void _increaseCounter() {
    if (_start) {
      setState(() {
        _counter++;
      });
    }
  }

  void _resetCounters() {
    setState(() {
      _start = false;
      _timer = _timeTimer;
      _lastTry = _counter;
      _bestTry = _counter > _bestTry ? _counter : _bestTry;
      _counter = 0;
    });
  }

  void _startCounter() {
    setState(() {
      _start = true;
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IgnorePointer(
        ignoring: !_start,
        child: Opacity(
            opacity: !_start ? 0.5 : 1.0,
            child: Column(children: [
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                decoration: BoxDecoration(
                    color: ColorsData.boxColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(children: [
                  Text(
                    "SECONDS",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: ColorsData.boxLetterColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    _timer.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0),
                  ),
                ]),
              ),
              const SizedBox(height: 25.0),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: ColorsData.buttonColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: FittedBox(
                  fit: BoxFit
                      .scaleDown, // Ajusta el contenido para que quepa dentro sin escalarlo más allá de su tamaño original.
                  child: TextButton(
                    onPressed: _increaseCounter,
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Text(
                      "$_counter",
                      style: TextStyle(
                        fontSize: 120.0,
                        color: ColorsData.boxNumberColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ])),
      ),
      const SizedBox(height: 25.0),
      Visibility(
        visible: !_start,
        child: Container(
          width: 120,
          height: 60,
          decoration: BoxDecoration(
              color: ColorsData.buttonColor,
              borderRadius: BorderRadius.circular(8.0)),
          child: TextButton(
              onPressed: () {
                setState(() {
                  _startCounter();
                });
              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => Colors
                    .transparent), // Color de resaltado al mantener presionado
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors
                    .transparent), // Color del botón cuando está deshabilitado, al mantener presionado y al pulsar
              ),
              child: Text(
                "START",
                style: TextStyle(
                  fontSize: 25.0,
                  color: ColorsData.boxNumberColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ),
      const SizedBox(height: 25.0),
    ]);
  }
}
