import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game.dart';

void main() async {
  //Allow only portrait mode on Android & iOS
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(
    const MaterialApp(
      home: Game(),
    ),
  );
}
