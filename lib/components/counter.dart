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
    required this.tries,
  });

  final VoidCallback onSaveStatistics;
  final Function(int, int, int) onUpdateInformation;
  final int lastTry;
  final ValueNotifier<int> bestTry;
  final ValueNotifier<int> tries;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final int _timeTimer = 2;
  int _timer = 2;
  int _lastTry = 0;
  int _bestTry = 0;
  int _tries = 0;
  Timer? _timerInstance;
  int _counter = 0;
  bool _last = false;

  @override
  void initState() {
    super.initState();
    _lastTry = widget.lastTry;
    _bestTry = widget.bestTry.value;
    _tries = widget.tries.value;

    widget.bestTry.addListener(() {
      setState(() {
        _bestTry = widget.bestTry.value;
      });
    });

    widget.tries.addListener(() {
      setState(() {
        _tries = widget.tries.value;
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
      widget.onUpdateInformation(_tries, _lastTry, _bestTry);
      widget.onSaveStatistics();
      _timerInstance?.cancel();
      _timerInstance = null;
      _last = false;
    }
  }

  void _increaseCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounters() {
    setState(() {
      _lastTry = _counter;
      _bestTry = _counter > _bestTry ? _counter : _bestTry;
      _counter = 0;
      _timer = _timeTimer;
    });
  }

  void _button() {
    if (_tries <= 0 && _last == false) {
    } else {
      if (_timerInstance == null) {
        _tries--;
        if (_tries == 0) {
          _last = true;
        }
        _startTimer();
      }
      if (_last || _tries > 0) {
        _increaseCounter();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: ColorsData.boxColor,
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(children: [
          Text(
            "Segundos Restantes",
            style: TextStyle(fontSize: 12.0, color: ColorsData.boxLetterColor),
          ),
          Text(
            _timer.toString(),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
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
