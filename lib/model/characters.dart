
import 'package:flutter/cupertino.dart';


class Characterss with ChangeNotifier{
  String name;
  String status;
  String species;
  String type;
  String gender;
  String originName;
  String originUrl;
  String locationName;
  String locationUrl;
  String image;
  List<String> episode;

  Characterss.fromMap(Map<String, dynamic> charactersMap)
      : name = charactersMap["name"] ?? "",
        status = charactersMap["status"] ?? "",
        species = charactersMap["species"] ?? "",
        type = charactersMap["type"] ?? "",
        gender = charactersMap["gender"] ?? "",
        originName = charactersMap["origin"]?["name"] ?? "",
        originUrl = charactersMap["origin"]?["url"] ?? "",
        locationName = charactersMap["location"]?["name"] ?? "",
        locationUrl = charactersMap["location"]?["url"] ?? "",
        image = charactersMap["image"] ?? "",
        episode = (charactersMap["episode"] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
            [];
}

