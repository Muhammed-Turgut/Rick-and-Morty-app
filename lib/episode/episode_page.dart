import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/episode/episode.dart';
import 'package:rick_and_morty_app/main_page.dart';

import 'episode_detail.dart';

class EpisodePage extends StatefulWidget {


  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {

  final String _EPISODE_API_URL = "https://rickandmortyapi.com/api/episode";
  List<String> _seasonsItemList = ["all","Season 1","Season 2","Season 3","Season 4","Season 5"
  ,"Season 6","Season 7","Season 8"];

  List<String> _seasonList = [
    "1,2,3,4,5,6,7,8,9,10,11", //1.sezon
    "12,13,14,15,16,17,18,19,20,21", //2.aezon
    "22,23,24,25,26,27,28,29,30,31", //3.sezon
    "32,33,34,35,36,37,38,39,40,41", //4.sezon
    "42,43,44,45,46,47,48,49,50,51", //5.sezon
    "52,53,54,55,56,57,58,59,60,61", //6.sezon
    "62,63,64,65,66,67,68,6970,71", //7.sezon
   "72,73,74,75,76,77,78,79,80,81"]; //8.sezon


  List<Episode> _allEpisode =[];
  List<Episode> _getEpisode = [];

  int _selectedSeason = 0;
  List<Episode> _selectedList = [];

  MainPage mainPage = MainPage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _allEpisodeInternet();
      _getSeason();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopBar(),
          _buildSeasonsField(context),
          SizedBox(height: 12),
          _buildEpisodeListField(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(){
    //Top bar
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text("Episode",
            style: TextStyle(
              color: Color(0xFF80C141),
              fontFamily: 'Almarai',
              fontWeight: FontWeight.bold,
              fontSize: 24
           ),
          ),

          SvgPicture.asset("assets/search_icon_svg.svg",
          width: 32,
          height: 28,)

       ],
      ),
    );

  }
  Widget _buildSeasonsField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/film_strip_icon.svg",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 4,),
              Text("Seasons",
                style: TextStyle(
                    color: Color(0xFF80C141),
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          const SizedBox(height: 16,),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(_seasonsItemList.length,
                (index) => GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedSeason = index;
                      _getSeason();
                    });
                  },
                  child: _buildSeasonListItem(context, index),
                ),
            ),
          ),


        ],
      ),
    );
  }
  Widget _buildSeasonListItem(BuildContext context, int index) {

    //Kullanıcı hangi indexteki değeri seçerse ona uygun filtre ile listeleme yapılıyor.

    if(index == _selectedSeason){

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Color(0xFF00B0C9),
            borderRadius: BorderRadius.circular(34)
        ),
        child: Text(
          _seasonsItemList[index],
          style:  TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 12,
            fontFamily: 'Almarai',
          ),
        ),
      );
    }

    else {

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(width: 1,color: Color(0xFF00B0C9))
        ),
        child: Text(
          _seasonsItemList[index],
          style:  TextStyle(
            color: Color(0xFF00B0C9),
            fontSize: 12,
            fontFamily: 'Almarai',
          ),
        ),
      );

    }



  }

  Widget _buildEpisodeListField(BuildContext context){

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: ListView.builder(
                itemBuilder: _buildEpisodeListItem,
                itemCount: _selectedList.length,
                shrinkWrap: true),

      ),
    );

  }

  Widget _buildEpisodeListItem(BuildContext context, int index) {

    final Episode episode = _selectedList[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(

        onTap: (){
          _routePage(EpisodeDetail(episode,index));
        },
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF00B0C9), width: 1)
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 4,left: 4,top: 4,bottom: 4),
          child: Row(
            children:[
            _buildEpisodeCharacterImageWidget(episode,index),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // yatay hizalama (sol)
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                              child: Text("${episode.name}",
                              style: TextStyle(
                                color: Color(0xFF00B0C9),
                                fontSize: 16,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold
                               ),
                              ),
                            ),


                        SvgPicture.asset("assets/favorite_default_row_icon.svg")
                       ],
                      ),

                    SizedBox(height: 4,),
                    Text("${episode.episode}",
                    style: TextStyle(
                       color: Color(0xFF80C141),
                      fontSize: 8,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold
                     ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/star_selected_icon.svg",
                        width: 10,
                        height: 10,),
                        SvgPicture.asset("assets/star_selected_icon.svg",
                          width: 10,
                          height: 10,),
                        SvgPicture.asset("assets/star_selected_icon.svg",
                          width: 10,
                          height: 10,),
                        SvgPicture.asset("assets/star_selected_icon.svg",
                          width: 10,
                          height: 10,),
                        SvgPicture.asset("assets/star_default_icon.svg",
                          width: 10,
                          height: 10,),
                        SizedBox(width: 4,),
                        Text("4.0",
                          style: TextStyle(
                            color: Color(0xFF80C141),
                            fontSize: 10,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w900
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              )
            ],
          ),
        ),
      ),
     )
    );

  }

  void _allEpisodeInternet() async {
    Uri uri = Uri.parse(_EPISODE_API_URL);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Map<String, dynamic>
      final List<dynamic> results = data["results"]; // liste burada

      _allEpisode.clear(); // önce listeyi temizle (tekrarı önlemek için)

      for (var episodeMap in results) {
        Episode episode = Episode.fromMap(episodeMap);
        _allEpisode.add(episode);
      }

      setState(() {});
    } else {
      debugPrint("Veri alınamadı: ${response.statusCode}");
    }
  }
  _buildEpisodeCharacterImageWidget(Episode episode, int index) {
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
      future: _getCharacterImage(characterUrl,index,episode),
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
  Future<String> _getCharacterImage(String characterURL, int index,Episode episode) async{

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

  void _getSeason() async{

    switch(_selectedSeason){
      case 0:
      _selectedList = _allEpisode;
      break;

      case 1:
      _selectedList = await _getApiList(_seasonList[0]);
      break;

      case 2:
        _selectedList = await _getApiList(_seasonList[1]);
        break;

      case 3:
        _selectedList = await _getApiList(_seasonList[2]);
        break;

      case 4:
        _selectedList = await _getApiList(_seasonList[3]);
        break;

      case 5:
        _selectedList = await _getApiList(_seasonList[4]);
        break;

      case 6:
        _selectedList = await _getApiList(_seasonList[5]);
        break;

      case 7:
        _selectedList = await _getApiList(_seasonList[5]);
        break;

      case 8:
        _selectedList = await _getApiList(_seasonList[7]);
        break;

      case 9:
        _selectedList = await _getApiList(_seasonList[8]);
        break;
    }


  }


  Future<List<Episode>> _getApiList(String getList) async {
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

      setState(() {});
    } else {
      debugPrint("API isteği başarısız: ${response.statusCode}");
    }

    return _list;
  }

  void _routePage(Widget routWidget){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    });

    Navigator.push(context, pageRoute);
  }

}
