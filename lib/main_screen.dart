
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rick_and_morty_app/view/main_page.dart';
import 'package:rick_and_morty_app/view/character/character_page.dart';
import 'package:rick_and_morty_app/view/episode/episode_page.dart';
import 'package:rick_and_morty_app/view/favorite/favorites_page.dart';
import 'package:rick_and_morty_app/view/location/locations_page.dart';
import 'model/bottom_nav_bar_item_model.dart';

class MainScreen extends StatefulWidget {

  int _getPage;

  MainScreen(this._getPage);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


    final List<BottomNavbarItemModel> _navBarItem = [
      BottomNavbarItemModel("assets/space_ship_selected_icon.svg","assets/space_ship_default_icon.svg","Main Page"),
      BottomNavbarItemModel("assets/character_selected_icon.svg","assets/character_default_icon.svg","Character"),
      BottomNavbarItemModel("assets/episode_selected_icon.svg","assets/episode_default_icon.svg","Episode"),
      BottomNavbarItemModel("assets/location_selected_icon.svg","assets/location_default_icon.svg","Location"),
      BottomNavbarItemModel("assets/favorite_selected_icon.svg","assets/favorite_default_icon.svg","Favorites")
    ];


    late int selectedIndex = widget._getPage;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

    //Widget Function
  Widget _buildBody(){
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _buildScreen())

        ],
      ),
    );
  }
  Widget _buildBottomBar(){
       return Container(
         width: double.infinity,
         height: 64,
         decoration: BoxDecoration(
           color: Color(0xFF05C6E1),
           borderRadius: const BorderRadius.only(
             topLeft: Radius.circular(16),
             topRight: Radius.circular(16)
           )
         ),
         child: Padding(
           padding: const EdgeInsets.only(left: 16,right: 16,top: 4,bottom: 4),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: List.generate(_navBarItem.length, (index){
               final item = _navBarItem[index];
               final isSelected = index == selectedIndex;

               return GestureDetector(
                 onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                 },
                 child: _buildBottomNavBarItem(item,isSelected)
               );
             }).toList(),
           ),
         ),
       );
  }
  Widget _buildBottomNavBarItem(BottomNavbarItemModel item, bool selected){

    String icon = selected ? item.selectIcon : item.defaultIcon;
    Color color;
    double iconSize;
    double fontSize;

    if(icon == item.selectIcon){
       color = Colors.white;
       iconSize = 32;
       fontSize = 12;
    }
    else{
       color = Color(0xFF008B9F);
       iconSize = 26;
       fontSize = 10;
    }

    return Column(
      children: [
        SvgPicture.asset("$icon",
        width:iconSize,
        height: iconSize,),
        SizedBox(height: 4,),
        Text("${item.label}",
        style: TextStyle(
          color: color,
           fontSize: fontSize,
           fontWeight: FontWeight.bold
         ),
        )
      ],
    );
  }
  Widget _buildScreen() {

    List<Widget> screenList = [
      MainPage(),

      CharacterPage(),

      EpisodePage(),

      LocationsPage(),

      FavoritesPage()];

    Widget selectedWidget = screenList[selectedIndex];

    return selectedWidget;
  }







}



