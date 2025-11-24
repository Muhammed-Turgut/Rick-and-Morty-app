import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/data/model/location.dart';
import 'package:rick_and_morty_app/main_screen.dart';
import 'package:rick_and_morty_app/view_model/location_detail_view_model.dart';
import 'locations_page.dart';


class LocationDetail extends StatefulWidget {
  Location location;
  String imageUrl;
  List<Location> _allLocation;

  LocationDetail(this.location,this.imageUrl,this._allLocation);

  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      LocationDetailViewModel viewModel = Provider.of<LocationDetailViewModel>(context,listen: false);
      viewModel.allCharactersLocation(widget.location);

     }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {

    return SafeArea(
        top: true,
        bottom: false,
        child:SingleChildScrollView(
      child: Column(
        children: [
          _buildTopBar(),
          _buildDetailLocation(),
          _buildResidentsField(),
          _buildMoreLocation(),
        ],
      ),
    )
    );
  }

  Widget _buildTopBar() {
    LocationDetailViewModel viewModel = Provider.of<LocationDetailViewModel>(context,listen: false);
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
              padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
              child: Column(children: [
                GestureDetector(
                  onTap: (){
                    viewModel.routePage(MainScreen(3),context);
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
                child: Consumer<LocationDetailViewModel>(builder: (context,viewModel,child)=>ListView.builder(
                  itemCount: viewModel.getAllCharacters.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: _buildCharacterListItem ,
                ),)
              ),

        ],
      ),
    );
  }
  Widget _buildCharacterListItem(BuildContext context, int index) {
    LocationDetailViewModel viewModel = Provider.of<LocationDetailViewModel>(context,listen: false);

    final character = viewModel.getAllCharacters[index];

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
    LocationDetailViewModel viewModel = Provider.of<LocationDetailViewModel>(context,listen: false);
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
                  viewModel.routePage(LocationsPage(),context);
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
              itemCount: viewModel.getAllCharacters.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: _buildLocationListItem ,
            ),
          ),
        ],
      ),
    );

  }



  Widget _buildLocationListItem(BuildContext context, int index) {
    LocationDetailViewModel viewModel = Provider.of<LocationDetailViewModel>(context,listen: false);

    Location location = widget._allLocation[index];
    String image = "https://ik.imagekit.io/eqxxgq5ve/${index+1}.png?updatedAt=1760875533841";

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: GestureDetector(
          onTap: (){
            viewModel.routePage(LocationDetail(location,image,widget._allLocation),context);
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
