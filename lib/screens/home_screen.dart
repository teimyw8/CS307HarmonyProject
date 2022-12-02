import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/all_chats_screen.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:harmony_app/providers/feed_provider.dart';
import 'package:harmony_app/screens/share_daily_activity_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _feedProvider.initializeVariables();
    });
    super.initState();
    _feedProvider.scheduleNotification();
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
            appBar: CustomAppBar(
              title: "Harmony",
              needBackArrow: false,
              needAvatar: true,
              needSettings: true,
              needFriendsList: true,
            ),
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                Container(
                    height: 837.h, width: double.infinity, child: getFeed()),
              ],
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
                    child: const Icon(Icons.history, color: Colors.green),
                    label: "Your Posts",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HistoryPosts()))),
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
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: AppColors.grey40,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
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
                                      PostDisplaySpotify(e),
                                      DailyDisplay(e),
                                      DailyBottomText(e)
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
        if ((e.song != null) && (e.artist != null) && (e.album == null || e.album == ""))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(
              e.song,
            style: AppTextStyles.headline(),
          ),
          Text(
              e.artist,
            style: AppTextStyles.footNote(),
          ),
            ],
          ),

        ///Sharing an artist
        if ((e.artist != null) && (e.song == null || e.song == "") && (e.album == null || e.album == ""))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.artist,
                style: AppTextStyles.headline(),
              ),
            ],
          ),

        ///sharing an album
        if ((e.artist != null) && (e.song == null || e.song == "") && (e.album != null))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.album,
                style: AppTextStyles.headline(),
              ),
              Text(
                e.artist,
                style: AppTextStyles.footNote(),
              ),
            ],
          ),

        ///This is for when the post is for a playlist
        if ((e.playlist != null))
          Column(
            children: [
              Text(e.playlist),
            ]
          )
      ],
    );
  }

  DailyDisplay(e) {
    if (e.isPost == "false") {
      return Container(
        child: ListTile(
          leading: Icon(Icons.album),
          title: Text(e.song),
          subtitle: Text(e.artist),
        ),
      );
    } else {
      return Container(
        child: ListTile(
          title: Text(e.text),
        ),
      );
    }
  }

  DailyBottomText(e) {
    if (e.isPost == 'false') {
      return Text(e.text, style: AppTextStyles.headline());
    } else {
      return const SizedBox.shrink();
    }
  }
}
