import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/field_validators.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/screens/security_screen.dart';
import 'package:harmony_app/services/spotify_service.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/top_item_list.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/top_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../widgets/common_widgets/custom_app_loader.dart';
import 'friends_list_screen.dart';
import '../widgets/common_widgets/shared_song_list.dart';

class SharedSongsScreen extends StatefulWidget {
  UserModel userModel;

  SharedSongsScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<SharedSongsScreen> createState() => SharedSongsScreenState();
}

class SharedSongsScreenState extends State<SharedSongsScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();

  int empty = 0;

  int length = 0;

  List commonElements = List.filled(10, '');
  List songs = List.filled(10, '');

  void genList() async {
    var data1 = await _firestoreService.retrieveUserFromFirestore(
        uid: widget.userModel.uid);
    var data2 = await _firestoreService.retrieveUserFromFirestore(
        uid: _editProfileProvider.currentUserModel!.uid);
    TopData user1 = TopData.fromJson(data1!);
    TopData user2 = TopData.fromJson(data2!);

    List lists = [user1.songs, user2.songs];

    commonElements = lists
        .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .toList();

    if (commonElements.length < 10) {
      length = commonElements.length;
    } else {
      length = 10;
    }

    for (int i = 0; i < length; i++) {
      songs[i] = commonElements[i];
    }
  }

  @override
  void initState() {
    super.initState();

    genList();
    if (songs[0] == "") {
      setState(() {
        songs[0] = "You have no shared songs";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider _authProvider =
        Provider.of<AuthProvider>(Get.context!, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<AuthProvider>(
        builder:
            (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
          return LoadingOverlay(
            isLoading: myAuthProvider.isLoading,
            progressIndicator: const CustomAppLoader(),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Scaffold(
                    appBar: CustomAppBar(
                      title: "Shared Songs",
                      needBackArrow: true,
                      needAvatar: false,
                      needSettings: false,
                      needHome: false,
                    ),
                    body: ListView.builder(
                      itemCount: length,
                      itemBuilder: (context, index) => Card(
                          child: ListTile(
                              title: Text(
                        songs[index],
                      ))),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
