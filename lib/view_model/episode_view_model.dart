import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/model/episode.dart';

class EpisodeViewModel with ChangeNotifier{

  final String _EPISODE_API_URL = "https://rickandmortyapi.com/api/episode";
  List<String> seasonsItemList = ["all","Season 1","Season 2","Season 3","Season 4","Season 5"
    ,"Season 6","Season 7","Season 8"];

  List<String> seasonList = [
    "1,2,3,4,5,6,7,8,9,10,11", //1.sezon
    "12,13,14,15,16,17,18,19,20,21", //2.aezon
    "22,23,24,25,26,27,28,29,30,31", //3.sezon
    "32,33,34,35,36,37,38,39,40,41", //4.sezon
    "42,43,44,45,46,47,48,49,50,51", //5.sezon
    "52,53,54,55,56,57,58,59,60,61", //6.sezon
    "62,63,64,65,66,67,68,6970,71", //7.sezon
    "72,73,74,75,76,77,78,79,80,81"]; //8.sezon


  List<Episode> allEpisode =[];
  List<Episode> getEpisode = [];

  int _selectedSeason = 0;

  int get selectedSeason => _selectedSeason;

  set selectedSeason(int value) {
    _selectedSeason = value;
    notifyListeners();
  }

  List<Episode> selectedList = [];





  void allEpisodeInternet() async {
    Uri uri = Uri.parse(_EPISODE_API_URL);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Map<String, dynamic>
      final List<dynamic> results = data["results"]; // liste burada

      allEpisode.clear(); // önce listeyi temizle (tekrarı önlemek için)

      for (var episodeMap in results) {
        Episode episode = Episode.fromMap(episodeMap);
        allEpisode.add(episode);
      }

    } else {
      debugPrint("Veri alınamadı: ${response.statusCode}");
    }
  }

  buildEpisodeCharacterImageWidget(Episode episode, int index) {
    if (episode.characters.isEmpty) {
      return Container(
        width: 140,
        height: 80,
        color: Colors.grey.shade200,
        child: Icon(Icons.person),
      );
    }

    final characterUrl = episode.characters[index];

    return FutureBuilder<String>(
      future: getCharacterImage(characterUrl,index,episode),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            width: 140,
            height: 80,
            color: Colors.grey.shade200,
            child: Icon(Icons.person),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            snapshot.data!,
            width: 140,
            height: 80,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
  Future<String> getCharacterImage(String characterURL, int index,Episode episode) async{

    //Bu fonksiyon elmanları tek tek getiriyor.

    int indexS = index%episode.characters.length;
    Uri  uri  = Uri.parse("https://rickandmortyapi.com/api/character/${indexS+1}");
    http.Response response = await http.get(uri);

    if(episode.characters.isNotEmpty){
      if(response.statusCode == 200 && episode.characters.length !=0){
        final Map<String, dynamic> data = jsonDecode(response.body);

        return data ["image"] ?? "";
      }
      else{
        return "https://rickandmortyapi.com/api/character/avatar/1.jpeg";
      }
    }
    else{
      return "https://rickandmortyapi.com/api/character/avatar/1.jpeg";
    }

  }

  void getSeason() async{

    switch(selectedSeason){
      case 0:
        selectedList = allEpisode;
        break;

      case 1:
        selectedList = await getApiList(seasonList[0]);
        break;

      case 2:
        selectedList = await getApiList(seasonList[1]);
        break;

      case 3:
        selectedList = await getApiList(seasonList[2]);
        break;

      case 4:
        selectedList = await getApiList(seasonList[3]);
        break;

      case 5:
        selectedList = await getApiList(seasonList[4]);
        break;

      case 6:
        selectedList = await getApiList(seasonList[5]);
        break;

      case 7:
        selectedList = await getApiList(seasonList[5]);
        break;

      case 8:
        selectedList = await getApiList(seasonList[7]);
        break;

      case 9:
        selectedList = await getApiList(seasonList[8]);
        break;
    }


  }


  Future<List<Episode>> getApiList(String getList) async {
    //Bu fonksiyon API dan bize veriyi getiriyor.

    Uri uri = Uri.parse("https://rickandmortyapi.com/api/episode/$getList");
    http.Response response = await http.get(uri);
    List<Episode> _list = [];
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // API bazen tek Map, bazen List döndürüyor:
      if (data is List) {
        for (var episodeMap in data) {
          Episode episode = Episode.fromMap(episodeMap);
          _list.add(episode);
        }
      } else if (data is Map<String, dynamic>) {
        // Bu durumda "results" alanı varsa oradan al
        if (data.containsKey("results")) {
          for (var episodeMap in data["results"]) {
            Episode episode = Episode.fromMap(episodeMap);
            _list.add(episode);
          }
        } else {
          // Tek bir episode olabilir
          _list.add(Episode.fromMap(data));
        }
      }
    } else {
      debugPrint("API isteği başarısız: ${response.statusCode}");
    }
    return _list;
  }

  void routePage(Widget routWidget,BuildContext context){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    });

    Navigator.push(context, pageRoute);
  }


}