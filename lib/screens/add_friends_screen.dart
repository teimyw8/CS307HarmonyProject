import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/add_friends_provider.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/add_friends_widgets/user_tile_widget.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_loader.dart';
import 'package:harmony_app/widgets/common_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({Key? key}) : super(key: key);

  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AddFriendsProvider _addFriendsProvider =
      Provider.of<AddFriendsProvider>(Get.context!, listen: false);

  @override
  void initState() {
    _addFriendsProvider.initializeVariables();
    super.initState();
  }

  @override
  void dispose() {
    _addFriendsProvider.disposeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Add Friends",
          needBackArrow: true,
        ),
        body: Consumer2<AddFriendsProvider, AuthProvider>(
          builder: (BuildContext context,
              AddFriendsProvider myAddFriendsProvider,
              AuthProvider myAuthProvider,
              Widget? child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(children: [
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 40.h,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "Add Friends",
                      style: AppTextStyles.headline().copyWith(fontSize: 32.sp),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.search,
                      size: 40.h,
                    ),
                    Expanded(
                      child: CustomTextField(
                        hintText: "Search...",
                        controller:
                            myAddFriendsProvider.searchBarEditingController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                if (myAddFriendsProvider.searchBarEditingController!.text
                    .trim()
                    .isNotEmpty)
                  StreamBuilder(
                    stream: _firestoreService.firebaseFirestore
                        .collection('users')
                        .where(
                          'username',
                          isGreaterThanOrEqualTo: myAddFriendsProvider
                              .searchBarEditingController!.text
                              .trim(),
                          isLessThan: myAddFriendsProvider
                                  .searchBarEditingController!.text
                                  .trim()
                                  .substring(
                                      0,
                                      myAddFriendsProvider
                                              .searchBarEditingController!.text
                                              .trim()
                                              .length -
                                          1) +
                              String.fromCharCode(myAddFriendsProvider
                                      .searchBarEditingController!.text
                                      .trim()
                                      .codeUnitAt(myAddFriendsProvider
                                              .searchBarEditingController!.text
                                              .trim()
                                              .length -
                                          1) +
                                  1),
                        )
                        .snapshots(), //myAddFriendsProvider.currentSnapshot,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) // TODO: show alert
                        return Text('Something went wrong');

                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Expanded(child: CustomAppLoader());

                      var len = snapshot.data!.docs.length;
                      if (len == 0) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("No users found",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey))
                            ],
                          ),
                        );
                      }

                      List<UserModel> users = snapshot.data!.docs
                          .map((doc) => UserModel.fromJson(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      return Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return (users[index].uid ==
                                      myAuthProvider.currentUserModel!.uid)
                                  ? Container()
                                  : SearchUserTileWidget(
                                      userModel: users[index],
                                      onSendFriendRequest: () =>
                                          myAddFriendsProvider
                                              .sendFriendRequest(
                                                  sendToUID: users[index].uid),
                                      isFriendRequestSent: myAuthProvider
                                          .currentUserModel!.friendRequestsSent
                                          .contains(users[index].uid),
                                    );
                              // return Text(users[index].toString());
                            }),
                      );
                    },
                  ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
