import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'components/ads.dart';
import 'game.dart';
import 'const/colors.dart';

AppOpenAdManager appOpenAdManager = AppOpenAdManager();
LoadingOverlay loadingOverlay = LoadingOverlay();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => const LoadingScreen(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsData.backgroundColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                color: ColorsData.iconColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: ColorsData.iconIcon,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Tap Ten',
            style: TextStyle(
              fontSize: 44.0,
              color: ColorsData.boxColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      loadingOverlay.show(context);
      await appOpenAdManager.showAdIfAvailable();
      loadingOverlay.hide();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      loadingOverlay.show(context);

      await appOpenAdManager.showAdIfAvailable();
      loadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Game();
  }
}
