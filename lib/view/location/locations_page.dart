import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/model/location.dart';

import 'location_detail.dart';

class LocationsPage extends StatefulWidget {


  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<Location> _allLocation = [];

  String _LOCATION_API_URL = "https://rickandmortyapi.com/api/location";
  

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getLocationInternet();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),

    );
  }

  Widget _buildBody() {
      return
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16,top: 16),
        child:
        Column(
        children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Locations",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF80C141)
                 )
                ),

                SvgPicture.asset("assets/search_icon_svg.svg")
              ],
            ),

            SizedBox(height: 16,),

            Expanded(
                child:ListView.builder(itemBuilder: _buildLocationItem,itemCount: _allLocation.length)
            )

          ],
        )
      );
  }

  void _getLocationInternet() async{

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

      setState(() {});

    } else{
       debugPrint("veri alınamadı: ${response.statusCode}");
    }
  }

  Widget _buildLocationItem(BuildContext context, int index) {
    
    Location location = _allLocation[index];
    
    String image = "https://ik.imagekit.io/eqxxgq5ve/${index+1}.png?updatedAt=1760875533841";
    
    
    return GestureDetector(
        onTap: (){
          _routePage(LocationDetail(location,image,_allLocation));
        },
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ClipRRect(
         borderRadius: BorderRadius.circular(16),
          child:Image.network(image,
            width: 381,
            height: 216,
            fit: BoxFit.cover) ,
        ),
        SizedBox(height: 4),
        Text("${location.name}",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai'
        ),
        ),

        SizedBox(height: 1,),

        Text("${location.type}",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontFamily: 'Almarai'
          ),
        ),
        SizedBox(height: 8,),

      ],
     )
    );
    
  }
  void _routePage(Widget routWidget){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return routWidget;

    }
    );

    Navigator.push(context, pageRoute);
  }

}


