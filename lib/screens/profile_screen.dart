import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/screens/list_of_friends_simple.dart';
import 'package:harmony_app/screens/shared_songs_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:harmony_app/models/top_model.dart';
import 'package:harmony_app/services/spotify_service.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../providers/edit_profile_provider.dart';
import '../services/firestore_service.dart';
import 'package:share_plus/share_plus.dart';

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

  List<String> songs = List.filled(5, '');

  List<String> artists = List.filled(5, '');

  List<String> genres = List.filled(5, '');

  List<String> titles = List.filled(3, '');

  GlobalKey _globalKey = new GlobalKey();

  Future<String?> _capturePng() async {
    try {
      print('inside');
      print(_globalKey.currentContext);
      RenderRepaintBoundary boundary =
      _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes!);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return bs64;
    } catch (e) {
      print(e);
    }
    return null;
  }

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
    print(widget.userModel.uid);
    print('\n$_editProfileProvider.currentUserModel!.uid');
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

  Future<void> _shareContent() async {
    Future<String?> temp = _capturePng();
    String? image = await temp;
    image ??= "";
    Share.share(image!);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userModel.profilepic);
    if (widget.isPrivate) {
      return Scaffold(
        key: _globalKey,
        appBar: CustomAppBar(
          title: "Harmony",
          needBackArrow: true,
          needSettings: true,
          needFriendsList: true,
        ),
        backgroundColor: AppColors.green,
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
        backgroundColor: AppColors.green,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: AppColors.green,
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
                                    .apply(color: AppColors.white),
                              )
                            : SizedBox()),
                        Row(
                          children: [
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
                            if (widget.userModel.uid
                                    .compareTo(_editProfileProvider.getUID()) ==
                                0)
                              ElevatedButton.icon(
                                  onPressed: _shareContent,
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share Profile'))
                          ],
                        ),
                        if (widget.userModel.uid !=
                            _editProfileProvider.currentUserModel!.uid)
                          ElevatedButton(
                              onPressed: () {
                                if (widget.userModel.spotifyToken == "") {
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
                                } else if (_editProfileProvider
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 0),
                child: Text(
                  widget.userModel.bio,
                  style: AppTextStyles.tileText().apply(color: AppColors.white),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  height: 60,
                  width: 400,
                  child: Text(
                    titles[0],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    songs[0],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    songs[1],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    songs[2],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    songs[3],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    songs[4],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  height: 40,
                  width: 300,
                  child: Text(
                    titles[1],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    artists[0],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    artists[1],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    artists[2],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    artists[3],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    artists[4],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  height: 40,
                  width: 300,
                  child: Text(
                    titles[2],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    genres[0],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    genres[1],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    genres[2],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    genres[3],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  height: 30,
                  width: 400,
                  color: const Color(0xDCDCDCCD),
                  child: Text(
                    genres[4],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
