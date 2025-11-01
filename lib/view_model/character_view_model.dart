
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/characters.dart';

class CharacterViewModel  with ChangeNotifier{

  List<Characterss> _allCharacterss =[];
  String _CHARACTER_API_URL = "https://rickandmortyapi.com/api/character";
  List<Characterss> get getAllCharacterss => _allCharacterss;

  set setAllCharacterss(List<Characterss> value) {
    _allCharacterss = value;
  }



  void getInternetAllCharacters() async {

    Uri uri = Uri.parse(_CHARACTER_API_URL);
    http.Response response = await http.get(uri);

    if(response.statusCode ==200){
      final data  = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      _allCharacterss.clear();

      for(var charactersMap in results){
        Characterss characterss = Characterss.fromMap(charactersMap);
        _allCharacterss.add(characterss);
      }

    }

    notifyListeners();

  }

  void routePage(Widget routWidget, BuildContext context){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    }
    );

    Navigator.push(context, pageRoute);
  }



}