import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/feed_provider.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
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
            body: Column(
              children: [
                Container(
                    height: 837.h, width: double.infinity, child: getFeed()),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePost()));
              },
              backgroundColor: AppColors.green,
              child: const Icon(Icons.add),
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

                  List<PostModel> posts = snapshot.data!.docs
                      .map((doc) => PostModel.fromJson(
                          doc.data() as Map<String, dynamic>))
                      .toList();
                  //sort the List in order to get chronological order
                  posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

                  //we want to remove all posts not from today

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
                                      Container(
                                          child: ListTile(
                                            leading: Icon(Icons.album),
                                            title: Text('Template song'),
                                            subtitle: Text('Artist template'),
                                          ),
                                      ),
                                      Text(e.text,
                                          style: AppTextStyles.headline())
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
}
