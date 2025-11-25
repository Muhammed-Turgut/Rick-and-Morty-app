import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CharacterDetailViewModel with ChangeNotifier{

  void routePage(Widget routWidget, BuildContext context){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    }
    );

    Navigator.push(context, pageRoute);
  }

}