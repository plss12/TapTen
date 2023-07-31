import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'components/buttons.dart';
import 'components/ads.dart';
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
  bool _colorMode = false;
  final String kLastAttemptKey = 'lastAttempt';
  final String kBestAttemptKey = 'bestAttempt';
  final String kTriesAttemptKey = 'triesAttempt';
  final String kColorMode = 'colorMode';

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
      _colorMode = prefs.getBool(kColorMode) ?? false;
      if (_colorMode) {
        ColorsData.toggleDarkMode();
      }
    });
  }

  void _saveStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kLastAttemptKey, _lastTry);
    await prefs.setInt(kBestAttemptKey, _bestTry.value);
  }

  void _updateInformation(int lastTry, int bestTry) {
    setState(() {
      _lastTry = lastTry;
      _bestTry.value = bestTry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsData.backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 80, bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        color: ColorsData.iconColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: ColorsData.iconIcon,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            ScoreBoard(label: '  SCORE  ', score: '$_lastTry'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ScoreBoard(
                            label: 'RECORD', score: '${_bestTry.value}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              child: Column(
                children: [
                  Counter(
                      lastTry: _lastTry,
                      bestTry: _bestTry,
                      onSaveStatistics: () => _saveStatistics(),
                      onUpdateInformation: (int lastTry, int bestTry) {
                        _updateInformation(lastTry, bestTry);
                      }),
                  ColorToggleButton(
                      onPressed: () => setState(() {
                            _colorMode = !_colorMode;
                            SharedPreferences.getInstance().then((prefs) =>
                                prefs.setBool(kColorMode, _colorMode));
                          })),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBannerAd(),
    );
  }
}
