import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/splash_screen.dart';

import 'episode/episode_detail.dart';
import 'main_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

