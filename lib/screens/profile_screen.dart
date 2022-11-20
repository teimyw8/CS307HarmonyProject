import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/screens/list_of_friends_simple.dart';
import 'package:harmony_app/screens/shared_songs_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/top_item_list.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:harmony_app/models/top_model.dart';
import 'package:harmony_app/services/path_service.dart';
import 'package:harmony_app/services/spotify_service.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../providers/edit_profile_provider.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModel;
  bool isPrivate;

  ProfileScreen({Key? key, required this.userModel, required this.isPrivate})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();

  //Design constants
  TextStyle primaryTextStyle = TextStyle();
  TextStyle secondaryTextStyle = TextStyle();

  Color primaryColor = AppColors.white;
  Color secondaryColor = AppColors.green;

  List<String> songs = List.filled(5, '');

  List<String> artists = List.filled(5, '');

  List<String> genres = List.filled(5, '');

  List<String> titles = List.filled(3, '');

  void setFriendsData() async {
    var dataTemp = await _firestoreService.retrieveUserFromFirestore(
        uid: widget.userModel.uid);
    setState(() {
      TopData test = TopData.fromJson(dataTemp!);
      int length;

      if (test.songs.length < 5) {
        length = test.songs.length;
      } else {
        length = 5;
      }

      for (int i = 0; i < length; i++) {
        songs[i] = test.songs[i];
      }

      if (test.artists.length < 5) {
        length = test.artists.length;
      } else {
        length = 5;
      }

      for (int i = 0; i < length; i++) {
        artists[i] = test.artists[i];
      }

      if (test.genres.length < 5) {
        length = test.genres.length;
      } else {
        length = 5;
      }

      for (int i = 0; i < length; i++) {
        genres[i] = test.genres[i];
      }
    });
  }

  void setSongs() async {
    List<TopSongModel> topSongs = await SpotifyService.getTopSongs();

    int length;

    if (topSongs.length < 5) {
      length = topSongs.length;
    } else {
      length = 5;
    }
    setState(() {
      for (int i = 0; i < length; i++) {
        songs[i] = topSongs[i].name;
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(_editProfileProvider.currentUserModel!.uid)
        .update({'topSongs': songs});
  }

  void setArtists() async {
    List<TopArtistModel> topArtists = await SpotifyService.getTopArtists();
    Set<String> genreSet = Set();
    int found = 0;
    //Generate genres
    for (TopArtistModel a in topArtists) {
      for (Object o in a.genres) {
        genreSet.add(o.toString());
      }
    }
    List<String> genreList = genreSet.toList();

    int length;

    if (genreSet.length < 5) {
      length = topArtists.length;
    } else {
      length = 5;
    }
    setState(() {
      for (int i = 0; i < length; i++) {
        genres[i] = genreList[i];
      }
    });

    if (topArtists.length < 5) {
      length = topArtists.length;
    } else {
      length = 5;
    }
    setState(() {
      for (int i = 0; i < length; i++) {
        artists[i] = topArtists[i].name;
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(_editProfileProvider.currentUserModel!.uid)
        .update({'topGenres': genres});

    FirebaseFirestore.instance
        .collection('users')
        .doc(_editProfileProvider.currentUserModel!.uid)
        .update({'topArtists': artists});
  }

  @override
  void initState() {
    super.initState();

    if (_editProfileProvider.currentUserModel!.uid != widget.userModel.uid) {
      if (widget.userModel.spotifyToken == "") {
        for (String s in songs) {
          s = "";
        }
        for (String s in artists) {
          s = "";
        }
        for (String s in genres) {
          s = "";
        }
        for (String s in titles) {
          s = "";
        }

        titles[0] =
            "Your friend must have their spotify account synced to see their analytics";
      } else {
        titles[0] = "Top Songs";
        titles[1] = "Top Artists";
        titles[2] = "Top Genres";
        setFriendsData();
      }
    } else {
      if (_editProfileProvider.currentUserModel!.spotifyToken == "") {
        for (String s in songs) {
          s = "";
        }
        for (String s in artists) {
          s = "";
        }
        for (String s in genres) {
          s = "";
        }
        for (String s in titles) {
          s = "";
        }

        titles[0] =
            "You must have your spotify account synced to see your analytics";
      } else {
        titles[0] = "Top Songs";
        titles[1] = "Top Artists";
        titles[2] = "Top Genres";
        setArtists();
        setSongs();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPrivate) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Harmony",
          needBackArrow: true,
          needSettings: true,
          needFriendsList: true,
        ),
        backgroundColor: secondaryColor,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 70),
                  child: Text(
                    "@${widget.userModel.username}",
                    style: AppTextStyles.profileNames(),
                  ),
                ),
              ],
            ),
            Text(
              "Private Page",
              style: AppTextStyles.tileText()
                  .apply(fontSizeDelta: 30, fontWeightDelta: 2),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Harmony",
          needBackArrow: true,
          needSettings: true,
          needFriendsList: true,
        ),
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: secondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfilePicture(
                      name: '',
                      radius: 65,
                      fontsize: 21,
                      img: _editProfileProvider.getUserProfilePic(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _editProfileProvider.getPrimaryName(widget.userModel),
                          style: AppTextStyles.profileNames(),
                        ),
                        (widget.userModel.displayName
                            ? Text(
                                "@${widget.userModel.username}",
                                style: AppTextStyles.subNote()
                                    .apply(color: secondaryColor),
                              )
                            : SizedBox()),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: AppTextStyles.button(),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListOfFriends(
                                        userModel: widget.userModel)));
                          },
                          child: const Text('Friends'),
                        ),
                        if (widget.userModel.uid !=
                            _editProfileProvider.currentUserModel!.uid)
                          ElevatedButton(
                              onPressed: () {
                                if (_editProfileProvider
                                        .currentUserModel!.spotifyToken ==
                                    "") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                          'You are not synced with spotify'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (widget.userModel.spotifyToken ==
                                    "") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                          'Your friend is not synced with spotify'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Get.to(() => SharedSongsScreen(
                                      userModel: widget.userModel));
                                }
                              },
                              child: Text("Shared Songs"))
                      ],
                    ),
                  ],
                ),
              ),

              //Bio
              Container(
                color: secondaryColor,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 17,
                    right: 17,
                    bottom: 20,
                  ),
                  child: Text(
                    widget.userModel.bio,
                    style: AppTextStyles.tileText().apply(color: primaryColor),
                  ),
                ),
              ),

              Column(
                children: [

                  TopItemList(fontSize: 15,),

                  TopItemList(fontSize: 15),

                  TopItemList(fontSize: 15),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
