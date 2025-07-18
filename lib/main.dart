import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_custom/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ChewieDemo());
}
