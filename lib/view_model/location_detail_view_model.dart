import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/model/characters.dart';
import 'package:rick_and_morty_app/data/model/location.dart';


class LocationDetailViewModel with ChangeNotifier{

  List<Characterss> _allCharacters = [];

  List<Characterss> get getAllCharacters => _allCharacters;

  set setAllCharacters(List<Characterss> value) {
    _allCharacters = value;
  }

  Future<void> allCharactersLocation(Location location) async{

    for(var residentsUrl in location.residents){
      final character = await getLocationCharacter(residentsUrl, location);

      if(character != null){

        getAllCharacters.add(character);

      }
    }
  }

  Future<Characterss?> getLocationCharacter(String url,Location location) async {

    if(location.residents.isEmpty) return null;
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    if(response.statusCode == 200){
      final Map <String, dynamic> data  = jsonDecode(response.body);
      return Characterss.fromMap(data);
    }
    else{
      print("Eror: ${response.statusCode}");
      return null;
    }
  }
  void routePage(Widget routWidget, BuildContext context){
    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){
      return routWidget;
      }
    );
    Navigator.push(context, pageRoute);
  }

}
