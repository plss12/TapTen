import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'components/buttons.dart';
// import 'components/adds.dart';
import 'components/counter.dart';
import 'components/info_board.dart';
import 'const/colors.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _lastTry = 0;
  final ValueNotifier<int> _bestTry = ValueNotifier<int>(0);
  final ValueNotifier<int> _tries = ValueNotifier<int>(5);
  final String kLastAttemptKey = 'lastAttempt';
  final String kBestAttemptKey = 'bestAttempt';
  final String kTriesAttemptKey = 'triesAttempt';

  final Buttons buttons = Buttons();

  @override
  void initState() {
    _loadStatistics();
    super.initState();
  }

  @override
  void dispose() {
    _saveStatistics();
    super.dispose();
  }

  void _loadStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastTry = prefs.getInt(kLastAttemptKey) ?? 0;
      _bestTry.value = prefs.getInt(kBestAttemptKey) ?? 0;
      _tries.value = prefs.getInt(kTriesAttemptKey) ?? 5;
    });
  }

  void _saveStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kLastAttemptKey, _lastTry);
    await prefs.setInt(kBestAttemptKey, _bestTry.value);
    await prefs.setInt(kTriesAttemptKey, _tries.value);
  }

  void _updateTries(int newTries) {
    setState(() {
      _tries.value = newTries;
    });
    _saveStatistics();
  }

  void _updateInformation(int tries, int lastTry, int bestTry) {
    setState(() {
      _tries.value = tries;
      _lastTry = lastTry;
      _bestTry.value = bestTry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsData.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 100,
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ScoreBoard(
                                      label: 'Intentos',
                                      score: '${_tries.value}'),
                                ),
                                buttons.moreTries(_tries.value, _updateTries),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ScoreBoard(
                                      label: 'Puntuación', score: '$_lastTry'),
                                ),
                                ColorToggleButton(
                                    onPressed: () => setState(() {})),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ScoreBoard(
                                      label: 'Record',
                                      score: '${_bestTry.value}'),
                                ),
                                buttons.lessTries(_tries.value, _updateTries),
                              ],
                            ),
                          ),
                        ])),
                  ])),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Counter(
                tries: _tries,
                lastTry: _lastTry,
                bestTry: _bestTry,
                onSaveStatistics: () => _saveStatistics(),
                onUpdateInformation: (int tries, int lastTry, int bestTry) =>
                    _updateInformation(tries, lastTry, bestTry),
              )),
        ],
      ),
    );
  }
}
