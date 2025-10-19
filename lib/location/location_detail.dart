import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/location/location.dart';
import 'package:rick_and_morty_app/main_screen.dart';

import '../character/characters.dart';
import 'locations_page.dart';


class LocationDetail extends StatefulWidget {

   Location location;
   String imageUrl;
   List<Location> _allLocation;

   LocationDetail(this.location,this.imageUrl,this._allLocation);

   List<Characterss> _allCharacterss = [];



  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){

       _allCharactersLocation(widget.location);

     }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTopBar(),
          _buildDetailLocation(),
          _buildResidentsField(),
          _buildMoreLocation(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {

    return SizedBox(
        height: 338,
        width: double.infinity,
        child:Stack(
          children: [
            Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(32)),
                  child:Image.network("${widget.imageUrl}",
                      width: 381,
                      height: 216,
                      fit: BoxFit.cover) ,
                )
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 24),
              child: Column(children: [
                GestureDetector(
                  onTap: (){
                    _routePage(MainScreen(3));
                  },
                  child: SvgPicture.asset("assets/back_arrow_icon.svg"),
                )
              ],
              ),
            )

          ],
        )
    );

  }
  Widget _buildDetailLocation() {

    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("${widget.location.name}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xFF00B0C9),
                    fontSize: 32,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold
                ),
              )),
              SvgPicture.asset("assets/favorite_icon.svg")
            ],
          ),

          Row(
            children: [
              Text("Type: ",
                style: TextStyle(
                    color: Color(0xFF80C141),
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold
                ),
              ),
              Text("${widget.location.type}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.normal
                ),
              )
            ],
          ),

          Row(
            children: [
              Text("Dimension: ",
                style: TextStyle(
                    color: Color(0xFF80C141),
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold
                ),
              ),
              Text("${widget.location.dimension}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.normal
                ),
              )
            ],
          )

        ],
      ),
    );

  }
  Widget _buildResidentsField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Residents",
                style: TextStyle(
                  color: Color(0xFF80C141),
                  fontSize: 24,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.bold
                ),
              ),
              ],
          ),

          SizedBox(
                height: 160, // 🔹 yüksekliği sabitle (en önemli adım!)
                child: ListView.builder(
                  itemCount: widget._allCharacterss.length,
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

    final character = widget._allCharacterss[index];

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            child: Image.network(
              character.image,
              width: 100,
              height: 124,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8,),

          Text(character.name)


        ],
      ),
    );

  }
  Widget _buildMoreLocation() {

    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text("More",
               style: TextStyle(
                color: Color(0xFF80C141),
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
                 fontFamily: 'Almarai'
               ),
             ),

              GestureDetector(
                onTap: (){
                  _routePage(LocationsPage());
                },
                child: Text("see all",
                style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Almarai'
                ),
              ),)

           ],
          ),
          SizedBox(
            height: 180, // 🔹 yüksekliği sabitle (en önemli adım!)
            child: ListView.builder(
              itemCount: widget._allCharacterss.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: _buildLocationListItem ,
            ),
          ),
        ],
      ),
    );

  }

  Future<void> _allCharactersLocation(Location location) async{

    for(var residentsUrl in widget.location.residents){
      final character = await _getLocationCharacter(residentsUrl, location);

      if(character != null){

        setState(() {

          widget._allCharacterss.add(character);


        });

      }
    }

  }
  Future<Characterss?> _getLocationCharacter(String url,Location location) async {

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
  void _routePage(Widget routWidget){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    }
    );

    Navigator.push(context, pageRoute);
  }







  Widget _buildLocationListItem(BuildContext context, int index) {
    Location location = widget._allLocation[index];
    String image = "https://ik.imagekit.io/eqxxgq5ve/${index+1}.png?updatedAt=1760875533841";





    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: GestureDetector(
          onTap: (){
            _routePage(LocationDetail(location,image,widget._allLocation));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:Image.network(image,
                    width: 178,
                    height: 101,
                    fit: BoxFit.cover) ,
              ),
              SizedBox(height: 4),
              Text("${location.name}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai'
                ),
              ),

              SizedBox(height: 1,),

              Text("${location.type}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Almarai'
                ),
              ),
              SizedBox(height: 8,),

            ],
          )
      ),
    );

  }
}
