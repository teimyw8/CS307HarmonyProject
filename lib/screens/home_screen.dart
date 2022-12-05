import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/screens/all_chats_screen.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:harmony_app/providers/feed_provider.dart';
import 'package:harmony_app/screens/public_rating_screen.dart';
import 'package:harmony_app/screens/share_daily_activity_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firestore_service.dart';
import '../widgets/common_widgets/custom_app_bar.dart';
import 'create_post.dart';
import 'friends_list_screen.dart';
import 'history_posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final FeedProvider _feedProvider =
      Provider.of<FeedProvider>(Get.context!, listen: false);
  final AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);


  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _feedProvider.initializeVariables();
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              title: "Harmony",
              needBackArrow: false,
              needAvatar: true,
              needSettings: true,
              needFriendsList: true,
            ),
            backgroundColor: AppColors.white,
            body: Consumer<FeedProvider>(
              builder: (BuildContext context, FeedProvider myFeedProvider, Widget? child) {
                if (!myFeedProvider.areVariablesInitialized) return const CustomAppLoader();
                return Column(
                  children: [
                    Expanded(
                      child: Container(width: double.infinity, child: getFeed()),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: SpeedDial(
              buttonSize: Size(75.0, 75.0),
              childrenButtonSize: Size(75.0, 75.0),
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 25.0),
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.add, color: Colors.green),
                    label: "Create Post",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreatePost()))),
                SpeedDialChild(
                    child: const Icon(Icons.music_note, color: Colors.green),
                    label: "Share Daily Song",
                    onTap: () => _feedProvider.activityTimeCheck(context)),
                SpeedDialChild(
                    child: const Icon(Icons.chat, color: Colors.green),
                    label: "Chats",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllChatsScreen()))),
                SpeedDialChild(
                    child: Icon(Icons.logout, color: Colors.green),
                    label: "Log Out",
                    onTap: () {
                      _authProvider.logOutUser();
                    }),
                SpeedDialChild(

                    child: const Icon(Icons.history, color: Colors.green),
                    label: "Your Posts",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HistoryPosts()))),
                SpeedDialChild(
                    child: const Icon(Icons.star, color: Colors.green),
                    label: "Music Rating Post",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PublicRating())))
              ],
            ),
          ),
        ],
      ),
    );
  }

  getFeed() {
    return Consumer2<FeedProvider, AuthProvider>(
      builder: (BuildContext context, FeedProvider myFeedProvider,
          AuthProvider myAuthProvider, Widget? child) {
        //add your UID to friends list locally for the querry
        //limitation of firestore querying, this is a work around
        List<dynamic> uidList = myFeedProvider.listOfUsers();

        //debugPrint("inside of home_screen" + myAuthProvider.currentUserModel.toString());
        //print(uidList.toString());
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 40.h),
            StreamBuilder(
                stream: _firestoreService.firebaseFirestore
                    .collection('posts')
                    .where('uid', whereIn: uidList)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  if (snapshot.data.isBlank == 0) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                              'Nothing to see here....',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Inter'),
                          ),
                        ],
                    );
                  }

                  List<PostModel> posts = snapshot.data!.docs
                      .map((doc) => PostModel.fromJson(
                          doc.data() as Map<String, dynamic>))

                      .toList();

                  //filter to only get the last days list of posts.
                  List postsFiltered = _feedProvider.lastDayOnly(posts);

                  return Expanded(
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: postsFiltered
                            .map((e) => Card(
                                  color: getColor(e),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: AppColors.grey40,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            e.username,
                                            style: AppTextStyles.headline(),
                                            textScaleFactor: 1.3,
                                          ),
                                          Spacer(),
                                          Text(
                                            "${DateTime.parse(e.dateTime.toDate().toString()).year}-${DateTime.parse(e.dateTime.toDate().toString()).month}-${DateTime.parse(e.dateTime.toDate().toString()).day}  ${DateTime.parse(e.dateTime.toDate().toString()).hour}:${DateTime.parse(e.dateTime.toDate().toString()).minute}",
                                            style: AppTextStyles.footNote(),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                        ],
                                      ),
                                      displayRatings(e),
                                      PostDisplaySpotify(e),
                                      DailyDisplay(e),
                                      //mainDisplay(e),
                                      showLikes(e, myAuthProvider),
                                      const Divider(
                                        color: Colors.grey,
                                      ),
                                      Center(child: DailyBottomText(e)),
                                    ],
                                  ),
                                ))
                            .toList()),
                  );
                }),
          ],
        );
      },
    );
  }

  PostDisplaySpotify(e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 5,),
        CircleAvatar(
          radius: 50,
          child: CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(e.image),
          ),
        ),
        const SizedBox(width: 20,),
        ///This is for when the post is for a song
        if ((e.song != "") && (e.artist != "") && (e.album == ""))
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.song,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.headline(),
                ),
                Text(
                  e.artist,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.footNote(),
                ),
              ],
            ),
          ),


        ///Sharing an artist
        if ((e.artist != "") && (e.song == "") && (e.album == ""))
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.artist,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.headline(),
                ),
              ],
            ),
          ),

        ///sharing an album
        if ((e.artist != "") && (e.song == "") && (e.album != ""))
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.album,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.headline(),
                ),
                Text(
                  e.artist,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.footNote(),
                ),
              ],
            ),
          ),

        ///This is for when the post is for a playlist
        if ((e.playlist != ""))
          Expanded(
            child: Text(
                e.playlist,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
                style: AppTextStyles.headline(),
            ),
          )
      ],
    );
  }

  DailyDisplay(e) {
    if (e.isPost == "false") {
      return Text("");
    } else {
      return Container(
        child: ListTile(
          title: Text(
            e.text,
            textScaleFactor: 1.2,
          ),
        ),
      );
    }
  }

  DailyBottomText(e) {
    if (e.isPost == 'false') {
      return Text(e.text, style: AppTextStyles.headline());
    } else {
      return Text("", style: AppTextStyles.headline());
    }
  }

  showLikes(e, myAuthProvider) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        FutureBuilder(
            future: _feedProvider.isLiked(
                e.uid, e.dateTime),
            builder: (BuildContext context,
                AsyncSnapshot<bool>
                snapshot) {
              if (snapshot.connectionState ==
                  "waiting") {
                return IconButton(
                  icon: Icon(Icons
                      .thumb_up_alt_outlined),
                  onPressed: () {
                    _feedProvider.handleLikes(
                        e.uid, e.dateTime);
                    setState(() {});
                  },
                );
              } else {
                if (snapshot.data ??
                    false == true) {
                  return IconButton(
                    icon:
                    Icon(Icons.thumb_up),
                    iconSize: 19.0,
                    onPressed: () {
                      _feedProvider
                          .handleLikes(e.uid,
                          e.dateTime);
                      //setState(() {});
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons
                        .thumb_up_alt_outlined),
                    onPressed: () {
                      _feedProvider
                          .handleLikes(e.uid,
                          e.dateTime);
                      //setState(() {});
                    },
                  );
                }
              }
            }),
        FutureBuilder(
          future: _feedProvider.getLikes(
              e.uid, e.dateTime),
          builder: (BuildContext context,
              AsyncSnapshot<String>
              snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.done) {
              print("done");
              return Text(snapshot.data ?? "",
                  style: TextStyle(
                      fontSize: 20));
            }
            return Text("",
                style:
                TextStyle(fontSize: 20));
          },
        ),
        Spacer(),
        if (myAuthProvider
            .currentUserModel!.uid !=
            e.uid)
          GestureDetector(
              onTap: () {
                print(e);
                ChatProvider chatProvider =
                Provider.of<ChatProvider>(
                    Get.context!,
                    listen: false);
                chatProvider
                    .showPostResponseDialog(
                    postModel: e);
              },
              child: Icon(Icons.message)),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }

  displayRatings(e) {
    if (e.rating <= 5.0) {
      return  Row(
        children: [Text("My Rating:", textScaleFactor: 1.5,), RatingBar.builder(
        initialRating: e.rating,
        minRating: 0,
        ignoreGestures: true,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.green,
        ),
        onRatingUpdate: (rtg) {
        },
      )
    ]
      );
    }
    return Text("");
  }

  getColor(e) {
    bool b = e.isPost.toLowerCase() == 'true';
    if (!b) {
      return Colors.yellow;
    }
    return Colors.white;
  }
}
