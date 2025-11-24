import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/data/model/location.dart';
import 'package:rick_and_morty_app/view_model/location_view_model.dart';
import 'location_detail.dart';

class LocationsPage extends StatefulWidget {
  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {

  @override
  void initState() {
    super.initState();
    
    Future.microtask((){
        Provider.of<LocationViewModel>(context,listen: false)
            .getLocationInternet();
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
            _buildListBuild()
          ],
        )
      );
  }

  Widget _buildListBuild() {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: viewModel.getAllLocation.length,
            itemBuilder: (context, index) {
              return _buildLocationItem(index);
            },
          ),
        );
      },
    );
  }


  Widget _buildLocationItem(int index) {

    return Consumer<LocationViewModel>(builder: (context,getLocation,child){
      Location location = getLocation.getAllLocation[index];
      String image = "https://ik.imagekit.io/eqxxgq5ve/${index+1}.png?updatedAt=1760875533841";

      return GestureDetector(
          onTap: (){
            getLocation.routePage(LocationDetail(location,image,getLocation.getAllLocation),context);
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
              SizedBox(height: 8,)
            ],
          )
      );
    });
  }
}