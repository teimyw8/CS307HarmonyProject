import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/screens/add_friends_screen.dart';
import 'package:harmony_app/screens/chat_screen.dart';
import 'package:harmony_app/screens/friend_requests_screen.dart';
import 'package:harmony_app/screens/profile_friends_screens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/widgets/add_friends_widgets/friends_list_app_bar.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/friends_list_provider.dart';
import '../widgets/add_friends_widgets/friends_list_view_widget.dart';

//this screen displays the friends list from the current user.
//it uses a stream builder to query the information from firestore
//it displays the informations in Cards

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final FriendsListProvider _friendsListProvider =
      Provider.of<FriendsListProvider>(Get.context!, listen: false);
  FriendsListAppBar? friendsListAppBar;

  @override
  void initState() {
    super.initState();
    friendsListAppBar = FriendsListAppBar(callback: this.callback);
  }

  void callback() {
    setState(() {}); //refresh this page to show any changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(
          ''
          'Harmony',
          style: AppTextStyles.appBar(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendRequestsScreen()));
              },
              icon: Icon(Icons.person_add)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddFriendsScreen()));
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                setState(() {}); //refresh this page to show any changes
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: <Widget>[
          Consumer<AuthProvider>(builder: (BuildContext context,
              AuthProvider myAuthProvider, Widget? child) {
            myAuthProvider.updateCurrentUser();
            currUser = (myAuthProvider.currentUserModel?.uid);
            friendsList = (myAuthProvider.currentUserModel?.friends)!;
            return const Text("");
          }),
      //appBar: friendsListAppBar,
      //body: Column(
      //  children: <Widget>[
      //    Expanded(
      //      child: Container(
      //          height: 500.h,
      //          width: double.infinity,
      //          child: const FriendsListViewWidget()),
      //    ),
      //  ],
      //),
    );
  }
}

void refresh() {
  Consumer<AuthProvider>(
    builder:
        (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
      myAuthProvider.updateCurrentUser();
      currUser = (myAuthProvider.currentUserModel?.uid);
      friendsList = (myAuthProvider.currentUserModel?.friends)!;
      return const SizedBox.shrink();
    },
  );
}

class friendsListView extends StatefulWidget {
  const friendsListView({Key? key}) : super(key: key);

  @override
  _friendsListViewState createState() => _friendsListViewState();
}
//get your own user id mcon
//returns json contains friends
//for each uid call the display
//

class _friendsListViewState extends State<friendsListView> {
  ChatProvider chatProvider = Provider.of<ChatProvider>(Get.context!, listen: false);
  AuthProvider authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    if (friendsList.isEmpty) {
      refresh();
      return Text(
        'No friends',
        style: AppTextStyles.headline(),
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("uid", whereIn: friendsList)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Error, reload');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: documents
                .map((e) => Card(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          friends_profile_screen(
                                            name: e['firstName'],
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: AppColors.white,
                            ),
                            child: Text(
                              e['firstName'],
                              style: TextStyle(color: AppColors.green),
                            ),
                          ),
                          Spacer(),
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  color: Colors.green,
                                  onPressed: () {
                                    chatProvider.openChatScreenFromFriendListWidget(uid1: authProvider.currentUserModel!.uid, uid2: e['uid']);
                                    // Get.to(ChatScreen(chatModel: null,));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    //debugPrint(e['uid']);
                                    var collection = FirebaseFirestore.instance
                                        .collection('users');
                                    collection.doc(currUser).update({
                                      'friends': FieldValue.arrayRemove(
                                          [e.get('uid')]),
                                    });
                                    collection.doc(e.get('uid')).update({
                                      'friends':
                                          FieldValue.arrayRemove([currUser]),
                                    });
                                    friendsList.remove(e['uid']);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList());
      },
    );
  }
}

