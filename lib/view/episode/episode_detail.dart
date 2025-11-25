import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/data/model/characters.dart';
import 'package:rick_and_morty_app/data/model/episode.dart';
import 'package:rick_and_morty_app/main_screen.dart';
import 'package:rick_and_morty_app/view_model/episode_detail_view_model.dart';


class EpisodeDetail extends StatefulWidget {

  Episode _episode;
  int _index;
  EpisodeDetail(this._episode,this._index);

  @override
  State<EpisodeDetail> createState() => _EpisodeDetailState();
}

class _EpisodeDetailState extends State<EpisodeDetail> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<EpisodeDetailViewModel>(context, listen: false);
      viewModel.allCharacterInternet();
      viewModel.allEpisodeInternet();
      viewModel.getSeason();
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
    return SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTopField(widget._episode, widget._index),
            SizedBox(height: 16,),
            _buildCharactersField(),
            _buildSeasonsField(context),
            SizedBox(height: 8,),
            _buildEpisodeListField(context)
          ],
        )
    );
  }

  Widget _buildSeasonsField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/film_strip_icon.svg",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 4,),
              Text("Seasons",
                style: TextStyle(
                    color: Color(0xFF80C141),
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          const SizedBox(height: 16,),

          Consumer<EpisodeDetailViewModel>(builder: (context,viewModel,child){
             return  Wrap(
               spacing: 12,
               runSpacing: 8,
               children: List.generate(viewModel.seasonsItemList.length,
                     (index) =>
                     GestureDetector(
                       onTap: () {

                           viewModel.selectedSeason = index;
                           viewModel.getSeason();

                       },
                       child: _buildSeasonListItem(context, index),
                     ),
               ),
             );
           }
          ),


        ],
      ),
    );
  }

  Widget _buildSeasonListItem(BuildContext context, int index) {
    return Consumer<EpisodeDetailViewModel>(
      builder: (context, viewModel, child) {
        final isSelected = index == viewModel.selectedSeason;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF00B0C9) : Colors.transparent,
            borderRadius: BorderRadius.circular(34),
            border: isSelected
                ? null
                : Border.all(width: 1, color: Color(0xFF00B0C9)),
          ),
          child: Text(
            viewModel.seasonsItemList[index],
            style: TextStyle(
              color: isSelected ? Colors.white : Color(0xFF00B0C9),
              fontSize: 12,
              fontFamily: 'Almarai',
            ),
          ),
        );
      },
    );
  }

  Widget _buildEpisodeListField(BuildContext context) {
    return Consumer<EpisodeDetailViewModel>(
        builder: (context, viewModel, child) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: ListView.builder(
                  itemBuilder: _buildEpisodeListItem,
                  itemCount: viewModel.selectedList.length,
                  shrinkWrap: true),

            ),
          );
        }
    );
  }

  Widget _buildEpisodeListItem(BuildContext context, int index) {

    return Consumer<EpisodeDetailViewModel>(builder: (context,viewModel,child){

      final Episode episode = viewModel.selectedList[index];

      return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(

            onTap: () {
              viewModel.routePage(EpisodeDetail(episode, index),context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF00B0C9), width: 1)
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 4, left: 4, top: 4, bottom: 4),
                child: Row(
                  children: [
                    viewModel.buildEpisodeCharacterImageWidget(episode, index),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // yatay hizalama (sol)
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("${episode.name}",
                                  style: TextStyle(
                                      color: Color(0xFF00B0C9),
                                      fontSize: 16,
                                      fontFamily: 'Almarai',
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),


                              SvgPicture.asset(
                                  "assets/favorite_default_row_icon.svg")
                            ],
                          ),

                          SizedBox(height: 4,),
                          Text("${episode.episode}",
                            style: TextStyle(
                                color: Color(0xFF80C141),
                                fontSize: 8,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/star_selected_icon.svg",
                                width: 10,
                                height: 10,),
                              SvgPicture.asset("assets/star_selected_icon.svg",
                                width: 10,
                                height: 10,),
                              SvgPicture.asset("assets/star_selected_icon.svg",
                                width: 10,
                                height: 10,),
                              SvgPicture.asset("assets/star_selected_icon.svg",
                                width: 10,
                                height: 10,),
                              SvgPicture.asset("assets/star_default_icon.svg",
                                width: 10,
                                height: 10,),
                              SizedBox(width: 4,),
                              Text("4.0",
                                style: TextStyle(
                                    color: Color(0xFF80C141),
                                    fontSize: 10,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w900
                                ),
                              )
                            ],
                          ),
                          Text("Lawnhower Dog"),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      );
    });

  }

  Widget _buildTopField(Episode episode, int index) {
    return Consumer<EpisodeDetailViewModel>(builder: (context,viewModel,child){
       return SizedBox(
         height: 200,
         child: Stack(
           children: [
             //  Arka plan resmi (FutureBuilder ile)
             Positioned.fill(
               child: viewModel.buildEpisodeCharacterImageWidget(
                   widget._episode, widget._index),
             ),

             // Üstteki içerikler
             Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(
                       left: 16.0, right: 16.0, top: 16.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       GestureDetector(
                         onTap: () {
                           viewModel.routePage(MainScreen(2),context);
                         },
                         child: SvgPicture.asset(
                           "assets/back_arrow_icon.svg",
                           width: 32,
                           height: 32,
                         ),
                       ),
                       SvgPicture.asset(
                         "assets/favorite_icon.svg",
                         width: 32,
                         height: 32,
                       ),
                     ],
                   ),
                 ),
                 SvgPicture.asset(
                   "assets/resume_button_icon.svg",
                   width: 42,
                   height: 42,
                 ),
                 Container(
                   width: double.maxFinite,
                   height: 90,
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       colors: [
                         Colors.white.withOpacity(0.01),
                         Colors.white.withOpacity(0.5),
                         Colors.white
                       ],
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                     ),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.only(left: 16, right: 16),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Text(
                           episode.name,
                           style: TextStyle(
                             fontSize: 32,
                             fontWeight: FontWeight.bold,
                             color: Color(0xFF00B0C9),
                             fontFamily: 'Almarai',
                           ),
                           textAlign: TextAlign.start,
                         ),
                         Text(
                           "${episode.air_date} - ${episode.episode}",
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                             color: Color(0xFF000000),
                             fontFamily: 'Almarai',
                           ),
                           textAlign: TextAlign.start,
                         )
                       ],
                     ),
                   ),
                 )
               ],
             ),
           ],
         ),
       );
     }
    );
  }

  Widget _buildCharactersField() {
    return Consumer<EpisodeDetailViewModel>(builder: (context,viewModel,child){

       return Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: const [
                 Text(
                   "Character",
                   style: TextStyle(
                     fontFamily: 'Almarai',
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                     color: Color(0xFF80C141),
                   ),
                 )
               ],
             ),
             const SizedBox(height: 12),
             // 🔹 Asıl yatay liste
             SizedBox(
               height: 160, // 🔹 yüksekliği sabitle (en önemli adım!)
               child: ListView.builder(
                 itemCount: viewModel.allCharacters.length,
                 scrollDirection: Axis.horizontal,
                 physics: const BouncingScrollPhysics(),
                 itemBuilder: _buildCharacterListItem,
               ),
             ),
           ],
         ),
       );
     }
    );
  }

  Widget _buildCharacterListItem(BuildContext context, int index) {

    return Consumer<EpisodeDetailViewModel>(builder: (context,viewModel, child){

      final character = viewModel.allCharacters[index];
     return Padding(
       padding: const EdgeInsets.only(right: 12.0),
       child: Container(
         width: 140,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(12),
               child: Image.network(
                 character.image,
                 width: 140,
                 height: 120,
                 fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) =>
                     Container(
                       width: 140,
                       height: 120,
                       color: Colors.grey.shade200,
                       child: const Icon(Icons.person, color: Colors.grey),
                     ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     character.name,
                     style: const TextStyle(
                       fontFamily: 'Almarai',
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF05C6E1),
                       fontSize: 12,
                     ),
                     overflow: TextOverflow.ellipsis,
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     );

     }
    );
  }
}
