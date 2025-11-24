import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/main_screen.dart';
import '../view_model/main_screen_view_model.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

    // Hide status bar and navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to MainScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ChangeNotifierProvider(
          create: (BuildContext create) => MainScreenViewModel(),
          child: MainScreen(0),
        )),
      );
    });
  }

  @override
  void dispose() {
    // Restore system UI overlays
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05C6E1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            Image.asset(
              "assets/rick_and_morty_title.png",
              width: 300,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "assets/rick_and_morty_splash_screen.png",
              width: 300,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
