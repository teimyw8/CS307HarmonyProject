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
/*              onHomeClicked: () {
                debugPrint(
                    'Temporary, must be deleted when we finalize the home page');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (FriendsListScreen())));
              },*/
            ),
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                Container(
                    height: 837.h, width: double.infinity, child: getFeed()),
              ],
            ),
            floatingActionButton: SpeedDial(
              buttonSize: Size(75.0,75.0),
              childrenButtonSize: Size(75.0,75.0),
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 25.0),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.add, color: Colors.green),
                    label: "Create Post",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreatePost()))
                ),
                SpeedDialChild(
                    child: Icon(Icons.music_note, color: Colors.green),
                    label: "Share Daily Song",
                    onTap: () => _feedProvider.activityTimeCheck(context)
                ),
                SpeedDialChild(
                    child: Icon(Icons.chat, color: Colors.green),
                    label: "Chats",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllChatsScreen()))
                ),
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
        print(uidList.toString());
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

                  if (snapshot.data == null) {
                    return Text('Waiting');
                  }

                  List<PostModel> posts = snapshot.data!.docs
                      .map((doc) => PostModel.fromJson(
                          doc.data() as Map<String, dynamic>)).toList();
                  //sort the List in order to get chronological order
                  //posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

                  //we want to remove all posts not from today
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
                                            "${DateTime.parse(e.dateTime
                                                        .toDate()
                                                        .toString())
                                                    .year}-${DateTime.parse(e.dateTime
                                                        .toDate()
                                                        .toString())
                                                    .month}-${DateTime.parse(e.dateTime
                                                        .toDate()
                                                        .toString())
                                                    .day}  ${DateTime.parse(e.dateTime
                                                        .toDate()
                                                        .toString())
                                                    .hour}:${DateTime.parse(e.dateTime.toDate().toString()).minute}",
                                            style: AppTextStyles.footNote(),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                        ],
                                      ),

                                      mainDisplay(e),
                                      handleBottomText(e),
                                      IconButton(
                                        icon: //await _feedProvider.isLiked(e.uid,e.dateTime)
                                          true? //this one checks in db if it is liked or not by this user to alter the icon
                                        Icon(Icons.thumb_up)
                                            :Icon(Icons.thumb_up_alt_outlined),

                                        onPressed: () {
                                          _feedProvider.isLiked(e.uid, e.dateTime); //this one swaps from liked to unliked in the icon
                                          // print(e.uid);
                                          // print(e.dateTime);
                                          // _feedProvider.handleLikes(e.uid, e.dateTime);
                                        },
                                      ),
                                      Text(_feedProvider.getLikes(e.uid, e.dateTime), style: TextStyle(fontSize: 20))
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

  mainDisplay(e) {
    if (e.isPost == "false") {
      return Container(
        child: ListTile(
          leading: Icon(Icons.album),
          title: Text(e.song),
          subtitle: Text(e.artist),
        ),
      );
    }
    else {
      return Container(
        child: ListTile(
          title: Text(e.text),
        ),
      );
    }
  }

  handleBottomText(e) {
    if (e.isPost == 'false') {
      return Text(e.text,
          style: AppTextStyles.headline());
    }
    else {
      return Text("",
          style: AppTextStyles.headline());
    }
  }

}
