import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/post_model.dart';
import '../providers/auth_provider.dart';
import '../providers/feed_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/common_widgets/custom_app_bar.dart';

class HistoryPosts extends StatefulWidget {
  const HistoryPosts({Key? key}) : super(key: key);

  @override
  _HistoryPostsState createState() => _HistoryPostsState();
}

class _HistoryPostsState extends State<HistoryPosts> {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final FeedProvider _feedProvider = Provider.of<FeedProvider>(Get.context!, listen: false);

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
                needBackArrow: true,
                needAvatar: false,
                needSettings: false,
                needFriendsList: false,
              ),
              backgroundColor: AppColors.white,
              body: Column(
                children: [
                  Container(
                      height: 837.h, width: double.infinity, child: getFeed()),
                ],
              ),
            )
          ]
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
                    .where('uid', isEqualTo: myAuthProvider.currentUserModel?.uid)
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
                      doc.data() as Map<String, dynamic>))
                      .toList();

                  //filter to only get the last days list of posts.
                  //List postsFiltered = _feedProvider.lastDayOnly(posts);

                  return Expanded(
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: posts
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
        if (!(e.song == null))
          Column(
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

        ///This is for when the post is for a playlist
        if (!(e.playlist == null))
          Column(
              children: [
                Text(e.playlist),
              ]
          )

        ///This is
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
