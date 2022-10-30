import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../helpers/colors.dart';
import '../../helpers/text_styles.dart';
import '../../providers/friends_list_provider.dart';

class FriendsListViewWidget extends StatefulWidget {
  const FriendsListViewWidget({Key? key}) : super(key: key);

  @override
  _FriendsListViewWidgetState createState() => _FriendsListViewWidgetState();
}
//get your own user id mcon
//returns json contains friends
//for each uid call the display
//

class _FriendsListViewWidgetState extends State<FriendsListViewWidget> {
  final FriendsListProvider _friendsListProvider =
      Provider.of<FriendsListProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    if (_friendsListProvider.friendsList.isEmpty) {
      _friendsListProvider.refresh();
      return Text(
        'No friends',
        style: AppTextStyles.headline(),
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("uid", whereIn: _friendsListProvider.friendsList)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Error, reload');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        UserModel? temp;
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
                              _friendsListProvider.getUserModel(temp, e['uid']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(userModel: temp!)));
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
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    //debugPrint(e['uid']);
                                    var collection = FirebaseFirestore.instance
                                        .collection('users');
                                    collection.doc(_friendsListProvider.currUser).update({
                                      'friends': FieldValue.arrayRemove(
                                          [e.get('uid')]),
                                    });
                                    collection.doc(e.get('uid')).update({
                                      'friends':
                                          FieldValue.arrayRemove([_friendsListProvider.currUser]),
                                    });
                                    _friendsListProvider.currUser.remove(e['uid']);
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
