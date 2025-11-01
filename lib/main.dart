import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/view/splash_screen.dart';
import 'package:rick_and_morty_app/view_model/character_view_model.dart';
import 'package:rick_and_morty_app/view_model/splash_screen_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
      ChangeNotifierProvider(create: (_) => CharacterViewModel()),
    ],
    child: MainApp(),
  ),);
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ChangeNotifierProvider(
        create: (BuildContext create) => SplashScreenViewModel(),
        child: SplashScreen(),
        )
    );
  }
}

