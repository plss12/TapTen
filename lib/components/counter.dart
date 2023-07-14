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
    required this.start,
  });

  final VoidCallback onSaveStatistics;
  final Function(int, int) onUpdateInformation;
  final int lastTry;
  final ValueNotifier<int> bestTry;
  final ValueNotifier<bool> start;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final int _timeTimer = 2;
  int _timer = 2;
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
    _start = widget.start.value;

    widget.bestTry.addListener(() {
      setState(() {
        _bestTry = widget.bestTry.value;
      });
    });

    widget.start.addListener(() {
      setState(() {
        _start = widget.start.value;
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
    setState(() {
      _counter++;
    });
  }

  void _resetCounters() {
    setState(() {
      _timer = _timeTimer;
      _lastTry = _counter;
      _bestTry = _counter > _bestTry ? _counter : _bestTry;
      _counter = 0;
    });
  }

  void _button() {
    if (_timerInstance == null && _start) {
      _startTimer();
      _increaseCounter();
    } else if (_start) {
      _increaseCounter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
            color: ColorsData.boxColor,
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(children: [
          Text(
            "SECONDS",
            style: TextStyle(
              fontSize: 16.0,
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
                fontSize: 24.0),
          ),
        ]),
      ),
      const SizedBox(height: 16.0),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextButton(onPressed: _button, child: Text("$_counter")))
    ]);
  }
}
