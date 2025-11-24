import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/model/location.dart';


class LocationViewModel with ChangeNotifier{
  List<Location> _allLocation = [];
  List<Location> get getAllLocation => _allLocation;
  set setAllLocation(List<Location> value) {
    _allLocation = value;

  }

  String _LOCATION_API_URL = "https://rickandmortyapi.com/api/location";

  void routePage(Widget routWidget, BuildContext context){
    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){
      return routWidget;
      }
    );
    Navigator.push(context, pageRoute);
  }


  void getLocationInternet() async{

    Uri  uri = Uri.parse(_LOCATION_API_URL);
    http.Response response = await http.get(uri);

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];

      _allLocation.clear();

      for(var locationMap in results){
        Location location = Location.fromMap(locationMap);
        _allLocation.add(location);
      }

    } else{
      debugPrint("veri alınamadı: ${response.statusCode}");
    }

    notifyListeners(); //Dinleyicilere değişiklik olduğuna dair haber veren sistem.
  }

}