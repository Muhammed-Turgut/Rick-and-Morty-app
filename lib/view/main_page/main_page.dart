
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/model/characters.dart';
import 'package:rick_and_morty_app/data/model/episode.dart';


class MainPage extends StatefulWidget {

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String _EPISODE_API_URL = "https://rickandmortyapi.com/api/episode";
  final String _CHARACTER_API_URL = "https://rickandmortyapi.com/api/character";

  List<Episode> _allEpisode = [];
  List<Characterss> _allCharacters = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _allEpisodeInternet();
      _allCharacterInternet();
     }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  //Widget function
  Widget _buildBody(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBar(),
            _buildEpisodeField(context),
            _buildCharacterField(context),
          ],
        ),
      ),
    );
  }

  //top bar widget
  Widget _buildTopBar(){

    return Stack(
      clipBehavior: Clip.none, // taştığında kesilmesini önler
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTopBarImage(),
            // İstersen burada diğer içerikler olabilir
            SizedBox(height: 100), // Stack içindeki Positioned ile çakışmayı ayarlamak için boşluk
          ],
        ),
        Positioned(
          top: 80, // _buildTopBar()'ın üstüne gelmesini istediğin miktar
          left: 60,
          right: 60,
          child: Container(
            width: 272,
            height: 154,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/coming_soon.png"),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildTopBarImage(){

    return  Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/app_top_bar_image.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: _buildTopBarContents()),
            ],
          ),
        ),
      ],
    );

  }
  Widget _buildTopBarContents(){

    return  Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 16,right: 16, top:18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/character_icon_image.png",
              width: 32,
              height: 34,),

            Image.asset("assets/search_icon.png",
              width: 32,
              height: 34,)
          ],
        ),
      ),
     ],
    );
  }

  //Episode List Widget
  Widget _buildEpisodeField(BuildContext context) {
    //Bu fonksiyon ekrandaki bölümler sayfasının değerlerini tutuyor.
    //liste boyutuna hazır oalrak 18 verdim çünkü çok uzun olunca hata oluşuyordu.
    //Bu şekilde hata çözülmüş oldu.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Episode",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF80C141),
                ),
              ),
              Text(
                "See all",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Color(0xFF6D6D6D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 Asıl yatay liste
          SizedBox(
            height: 160, // 🔹 yüksekliği sabitle (en önemli adım!)
            child: ListView.builder(
              itemCount: 18,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: _buildListItem ,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildListItem(BuildContext context, int index) {
    final episode = _allEpisode[index];

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEpisodeCharacterImageWidget(episode,index),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.name,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05C6E1),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    episode.episode,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF91C560),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    episode.air_date,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      color: Color(0xFF959595),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEpisodeCharacterImageWidget(Episode episode ,int index) {
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


  //Character List Widget
  Widget _buildCharacterField(BuildContext context) {
    //Bu fonksiyon ekrandaki bölümler sayfasının değerlerini tutuyor.
    //liste boyutuna hazır oalrak 18 verdim çünkü çok uzun olunca hata oluşuyordu.
    //Bu şekilde hata çözülmüş oldu.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Character",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF80C141),
                ),
              ),
              Text(
                "See all",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Color(0xFF6D6D6D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 Asıl yatay liste
          SizedBox(
            height: 160, // 🔹 yüksekliği sabitle (en önemli adım!)
            child: ListView.builder(
              itemCount: _allCharacters.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: _buildCharacterListItem ,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCharacterListItem(BuildContext context, int index) {
    final character = _allCharacters[index];

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                character.image,
                width: 140,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 140,
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05C6E1),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  //Normal function
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

  void _allCharacterInternet() async{
  Uri uri = Uri.parse(_CHARACTER_API_URL);
  http.Response response = await http.get(uri);

  if(response.statusCode  == 200 ){
    final data = jsonDecode(response.body);
    final List<dynamic> results = data["results"];
    _allCharacters.clear();

    for(var characterMap in results){
      Characterss characterss = Characterss.fromMap(characterMap);
      _allCharacters.add(characterss);
    }
    setState(() {});

  }
  }

  Future<String> _getCharacterImage(String characterURL, int index,Episode episode) async{

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

}
