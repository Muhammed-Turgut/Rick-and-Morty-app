import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/data/model/episode.dart';
import 'package:rick_and_morty_app/view/main_page/main_page.dart';
import 'package:rick_and_morty_app/view_model/episode_view_model.dart';
import 'episode_detail.dart';

class EpisodePage extends StatefulWidget {
  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  MainPage mainPage = MainPage();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<EpisodeViewModel>(context, listen: false);
      viewModel.allEpisodeInternet();
      viewModel.getSeason();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopBar(),
          _buildSeasonsField(context),
          SizedBox(height: 12),
          _buildEpisodeListField(context),
        ],
      ),
    );
  }
  Widget _buildTopBar(){
    //Top bar
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text("Episode",
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
  Widget _buildSeasonsField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
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
          Consumer<EpisodeViewModel>(builder: (context,viewModel,child){
             return Wrap(
               spacing: 12,
               runSpacing: 8,
               children: List.generate(viewModel.seasonsItemList.length,
                     (index) => GestureDetector(
                   onTap: (){

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
    return Consumer<EpisodeViewModel>(
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

  Widget _buildEpisodeListField(BuildContext context){
    return Consumer<EpisodeViewModel>(
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

    return Consumer<EpisodeViewModel>(
        builder: (context, viewModel, child) {
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
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
                                  SvgPicture.asset(
                                    "assets/star_selected_icon.svg",
                                    width: 10,
                                    height: 10,),
                                  SvgPicture.asset(
                                    "assets/star_selected_icon.svg",
                                    width: 10,
                                    height: 10,),
                                  SvgPicture.asset(
                                    "assets/star_selected_icon.svg",
                                    width: 10,
                                    height: 10,),
                                  SvgPicture.asset(
                                    "assets/star_selected_icon.svg",
                                    width: 10,
                                    height: 10,),
                                  SvgPicture.asset(
                                    "assets/star_default_icon.svg",
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
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        }
    );
  }
}