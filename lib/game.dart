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
  final ValueNotifier<bool> _start = ValueNotifier<bool>(false);
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
    });
  }

  void _saveStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kLastAttemptKey, _lastTry);
    await prefs.setInt(kBestAttemptKey, _bestTry.value);
  }

  void _updateInformation(int lastTry, int bestTry) {
    setState(() {
      _start.value = false;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ColorToggleButton(
                                        onPressed: () => setState(() {})),
                                  ),
                                ],
                              )),
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
                              ],
                            ),
                          ),
                        ])),
                  ])),
          IgnorePointer(
            ignoring: !_start.value,
            child: Opacity(
              opacity: !_start.value ? 0.5 : 1.0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Counter(
                      start: _start,
                      lastTry: _lastTry,
                      bestTry: _bestTry,
                      onSaveStatistics: () => _saveStatistics(),
                      onUpdateInformation: (int lastTry, int bestTry) {
                        _updateInformation(lastTry, bestTry);
                      })),
            ),
          ),
          Visibility(
              visible: !_start.value,
              child: Container(
                  //padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: ColorsData.boxColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      icon: ColorsData.startIcon,
                      color: ColorsData.boxNumberColor,
                      tooltip: 'Comenzar',
                      onPressed: () {
                        setState(() {
                          _start.value = true;
                        });
                      },
                    )
                  ]))),
        ],
      ),
    );
  }
}
