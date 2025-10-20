import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/character/characters.dart';
import 'package:rick_and_morty_app/main_screen.dart';

import 'character_detail.dart';

class CharacterPage extends StatefulWidget {

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {

  List<Characterss> _allCharacterss =[];
  String _CHARACTER_API_URL = "https://rickandmortyapi.com/api/character";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){

        _getInternetAllCharacters();

      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {

    return Column(
      children: [
         _buildTopBar(),
        Expanded(child: _buildCharactersList())
      ],
    );

  }


  Widget _buildTopBar() {

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Characters",
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
  Widget _buildCharactersList() {

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _allCharacterss.length,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: _buildCharacterListItem,
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterListItem(BuildContext context, int index) {

    Characterss characterss = _allCharacterss[index];

    return GestureDetector(
      onTap: (){
        _routePage(CharacterDetail(characterss));
      },
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFE6E6E6),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [

           Padding(
             padding: const EdgeInsets.only(left: 8.0,right: 12),
             child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Image.network(
                   characterss.image,
                   width: 68.04,
                   height: 82.33,
                  fit: BoxFit.cover,
                  )
                ),
           ),


              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(characterss.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xFF00B0C9),
                          fontSize: 24,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.bold
                      ),
                     )
                    ),

                    Row(children: [
                       Text("status: ",
                       style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w400,
                         color: Color(0xFF656565)
                        ),
                       ),

                      Text(characterss.status,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF80C141)
                        ),
                      )

                     ],
                    ),
                    Row(children: [
                      Text("species: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF656565)
                        ),
                      ),

                      Text(characterss.species,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF80C141)
                        ),
                      )

                    ],
                    ),
                    Row(children: [
                      Text("gender: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF656565)
                        ),
                      ),

                      Text(characterss.gender,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF80C141)
                        ),
                      )

                    ],
                    )
                  ],
                ),
              )
          ],
        ),
       )
       )

    );

  }

  void _getInternetAllCharacters() async {

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
      setState(() {});
    }

  }

  void _routePage(Widget routWidget){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    }
    );

    Navigator.push(context, pageRoute);
  }




}
