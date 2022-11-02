import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/field_validators.dart';
import 'package:harmony_app/models/top_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/services/path_service.dart';
import 'package:harmony_app/services/spotify_service.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../widgets/common_widgets/custom_app_loader.dart';
import '../providers/auth_provider.dart';
import 'friends_list_screen.dart';

class UserAnalyticsScreen extends StatefulWidget {
  const UserAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
}

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {
  final EditProfileProvider _editProfileProvider =
  Provider.of<EditProfileProvider>(Get.context!, listen: false);
  UserModel? temp;

  int _syncState = 0;
  String _errorMessage = '';

  List<String> songs = List.filled(5, 'N/A');

  List<String> artists = List.filled(5, 'N/A');

  List<String> genres = List.filled(5, 'N/A');


  void setSongs() async{

    List<TopSongModel> topSongs = await SpotifyService.getTopSongs();

    int length;

    if(topSongs.length < 5){
      length = topSongs.length;
    } else {
      length = 5;
    }
    setState(() {
      for(int i = 0; i < length; i++){
        songs[i] = topSongs[i].name;
      }
    });

  }

  void setArtists() async {
    List<TopArtistModel> topArtists = await SpotifyService.getTopArtists();

    int length;

    if(topArtists.length < 5){
      length = topArtists.length;
    } else {
      length = 5;
    }
    setState(() {
      for(int i = 0; i < length; i++){
        artists[i] = topArtists[i].name;
      }
    });

  }

  void setGenres(){

  }

  _test() {
    print("");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AuthProvider _authProvider =
    Provider.of<AuthProvider>(Get.context!, listen: false);
    String token = _authProvider.currentUserModel!.spotifyToken;
    print("TEST$token\n");

    if (token == '') {
      setState(() {
        _syncState = 0;
      });
    } else {
      setState(() {
        _syncState = 1;
      });
    }
    setArtists();
    //sleep(Duration(milliseconds: 50));
    setGenres();
    setSongs();
  }

  @override
  Widget build(BuildContext context) {
    if (_syncState == 1) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<AuthProvider>(
        builder:
            (BuildContext context, AuthProvider myAuthProvider,
            Widget? child) {
          return LoadingOverlay(
            isLoading: myAuthProvider.isLoading,
            progressIndicator: const CustomAppLoader(),
            child: Stack(alignment: AlignmentDirectional.topStart, children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: "Analytics",
                  needBackArrow: true,
                  needAvatar: true,
                  needSettings: false,
                  needHome: true,
                  onHomeClicked: () {
                    debugPrint(
                        'Temporary, must be deleted when we finalize the home page');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (FriendsListPage())));
                  },
                ),
                backgroundColor: AppColors.white,
                body: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _editProfileProvider.formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /* Title */
                              Container(
                                height: 40,
                                width: 300,
                                child: const Text("Top Songs",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,

                                  ),
                                ),

                              ),
                              /* Song 1 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),

                                child:  Text(songs[0],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                              ),
                              /* Song 2 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(songs[1],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                              ),
                              /* Song 3 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(songs[2],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(songs[3],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(songs[4],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              /* Title */
                              Container(
                                height: 40,
                                width: 300,
                                child: const Text("Top Artists",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,

                                  ),
                                ),

                              ),
                              /* Song 1 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),

                                child:  Text(artists[0],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                              ),
                              /* Song 2 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(artists[1],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              /* Song 3 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(artists[2],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(artists[3],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(artists[4],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                child: const Text("Top Genres",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,

                                  ),
                                ),


                              ),
                              /* Song 1 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),

                                child:  Text(genres[0],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                              ),
                              /* Song 2 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(genres[1],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              /* Song 3 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(genres[2],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(genres[3],
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xDCDCDCCD),
                                child:  Text(genres[4],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }  else {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Consumer<AuthProvider>(
          builder:
              (BuildContext context, AuthProvider myAuthProvider,
              Widget? child) {
            return LoadingOverlay(
              isLoading: myAuthProvider.isLoading,
              progressIndicator: const CustomAppLoader(),
              child: Stack(alignment: AlignmentDirectional.topStart, children: [
                Scaffold(
                  appBar: CustomAppBar(
                    title: "Analytics",
                    needBackArrow: true,
                    needAvatar: true,
                    needSettings: false,
                    needHome: true,
                    onHomeClicked: () {
                      debugPrint(
                          'Temporary, must be deleted when we finalize the home page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (FriendsListPage())));
                    },
                  ),
                  backgroundColor: AppColors.white,
                  body: SingleChildScrollView(
                    padding:
                    EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _editProfileProvider.formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                /* Title */
                                 Container(
                                   width: 400,
                                   height: 100,
                                   child:  const Text("You must sync with spotify to see your analytics",
                                   style: const TextStyle(fontSize: 20),
                                   ),
                                 ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
      );
    }
  }
 // }
}
