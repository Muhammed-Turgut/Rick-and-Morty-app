import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/data/model/characters.dart';
import 'package:rick_and_morty_app/main_screen.dart';
import 'package:rick_and_morty_app/view_model/character_detail_view_model.dart';


class CharacterDetail extends StatelessWidget {

  Characterss characterss;
  CharacterDetail(this.characterss);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),);
  }

  Widget _buildBody(BuildContext context) {

    return SafeArea(
        top: true,
        bottom: false,
        child:Container(

      color: Color(0xff80c141),
      child: Column(
        children: [
          _buildTopBar(context),
          _buildImageField(),
          SizedBox(height: 24,),
          _buildAboutCharacter()
        ],
      ),
     )
    );

  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( left: 16.0, right: 16,top: 16),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           GestureDetector(
             onTap: (){

               CharacterDetailViewModel viewModel = Provider.of<CharacterDetailViewModel>(context,listen: false);
               print("Tıklandı");
               viewModel.routePage(MainScreen(1),context);

             },
               child:
           SvgPicture.asset("assets/back_arrow_icon.svg",width: 32,height: 32) ),
           SvgPicture.asset("assets/favorite_icon.svg",width: 32,height: 32)
         ],
      ),
    );
  }

  Widget _buildImageField() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${characterss.name}",
        style: TextStyle(
          fontSize: 42,
          fontFamily: 'GtPro',
          fontStyle: FontStyle.italic,
          color: Color(0xFF68A330)
         ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Image.network(characterss.image,
          width: 232,
          height: 280,
          fit: BoxFit.cover,),
        )
      ],
    );

  }

  Widget  _buildAboutCharacter() {

    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 24,),
              Text("About Character",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                ),
              ),

              SizedBox(height: 24,),

              _buildAboutList()



            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Color(0xFF00B0C9),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
        ),
      ),
    );

  }

  Widget _buildAboutList() {

    return Column(
      children: [
        Row(
          children: [
            Text("Name: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),

            Text(characterss.name,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
            )
          ],
        ),

        Row(
          children: [
            Text("Status: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),

            Text(characterss.status,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
            )
          ],
        ),

        Row(
          children: [
            Text("Species: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),

            Text(characterss.species,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
            )
          ],
        ),

        Row(
          children: [
            Text("Type: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),

            Text(characterss.type,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
            )
          ],
        ),

        Row(
          children: [
            Text("Gender: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),

            Text(characterss.gender,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
            )
          ],
        ),

        Row(
          children: [
            Text("Origin: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),


            Expanded(
              child: Text(characterss.originName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            )
          ],
        ),

        Row(
          children: [
            Text("Location: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
            ),

            Expanded(
              child: Text(characterss.locationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
