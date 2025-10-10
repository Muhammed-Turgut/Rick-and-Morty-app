
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/main_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _splashScreenTransition(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF05C6E1),
      body: Center(
        child:  Column(
          mainAxisSize: MainAxisSize.min,           // Column sadece içeriği kadar alan kaplar
          mainAxisAlignment: MainAxisAlignment.center, // dikey ortala (içindeki öğeler)
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 64,),
            Image.asset("assets/rick_and_morty_title.png",
                width: 300,
                fit: BoxFit.fill),

            Image.asset("assets/rick_and_morty_splash_screen.png",
              width: 300,
            fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }

  void _splashScreenTransition(BuildContext context){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return MainScreen();

    });

    _timer = Timer.periodic(Duration(seconds: 3), (timer){
         Navigator.push(context, pageRoute);
     }
    );

  }
}