
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'model/bottom_nav_bar_item_model.dart';

class MainScreen extends StatelessWidget {
  List<dynamic> bottomBarItem = [];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  Widget _buildBody(){
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTopBar(),
          //_buildBottomNavBar()
        ],
      ),
    );
  }

  Widget _buildTopBar(){

    return Container(
       height: 160,
       decoration: BoxDecoration(
       image: DecorationImage(image: AssetImage("assets/app_top_bar_image.png"),
       fit: BoxFit.cover),
       ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
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
          )
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
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [



           ],
         ),
       );
  }

  Widget _buildBottomNavBarItem(BottomNavbarItemModel item, bool selected){

    String icon;

    if(selected){
      icon = item.selectIcon;
    }
    else{
      icon = item.defaultIcon;
    }

    return Column(
      children: [
        SvgPicture.asset("$icon}"),
        Text("${item.label}")
      ],
    );
  }

}


/*

BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: SvgPicture.asset("assets/character_default_icon.svg",
          width: 28,
          height: 28),
            label: 'Character'),
        BottomNavigationBarItem(icon: SvgPicture.asset("assets/episode_default_icon.svg",
          width: 28,
          height: 28)
            , label: 'Location'),
        BottomNavigationBarItem(icon: SvgPicture.asset("assets/location_default_icon.svg",
          width: 28,
          height: 28),
            label: 'Episode'),
        BottomNavigationBarItem(icon: SvgPicture.asset("assets/favorite_default_icon.svg",
          width: 28,
          height: 28)
            , label: 'Favorites')
      ],
 */
