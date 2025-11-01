

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/model/characters.dart';
import 'package:rick_and_morty_app/view_model/character_view_model.dart';

import 'character_detail.dart';

class CharacterPage extends StatefulWidget {


  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
       Provider.of<CharacterViewModel>(context,listen: false)
           .getInternetAllCharacters();
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

    return Consumer<CharacterViewModel>(builder: (context,viewModel,child){
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.getAllCharacterss.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return ChangeNotifierProvider.value(
                    value: viewModel.getAllCharacterss[index],
                    child: _buildCharacterListItem(index),
                  );
                },
              ),
            ),
          ],
        );
     }
    );
  }

  Widget _buildCharacterListItem(int index) {

    return Consumer<CharacterViewModel>(builder: (context,character,child){
      Characterss characterss = character.getAllCharacterss[index];
         return  GestureDetector(
             onTap: (){
               character.routePage(CharacterDetail(characterss),context);
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
    );

  }
}
