
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }
  //Widget function
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

}
