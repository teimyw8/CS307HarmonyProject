

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../helpers/colors.dart';
import '../../helpers/text_styles.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/friends_list_provider.dart';

List<dynamic>? friendsList;

class simpFriendsListWidget extends StatefulWidget {
  UserModel userModel;
  simpFriendsListWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  _simpFriendsListWidgetState createState() => _simpFriendsListWidgetState();
}

class _simpFriendsListWidgetState extends State<simpFriendsListWidget> {
  final FriendsListProvider _friendsListProvider =
  Provider.of<FriendsListProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider myAuthProvider,
        Widget? child) {

      friendsList = widget.userModel.friends;

      if (friendsList!.isEmpty) {
        return Text(
          'No friends',
          style: AppTextStyles.headline(),
        );
      }

      if (friendsList!.last.toString() == widget.userModel.uid.toString()) {
        friendsList?.removeLast();
      }

          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", whereIn: friendsList)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasError) {
                  return const Text('Error, reload');
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: documents
                      .map((e) =>
                      Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {},
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
                                    icon: const Icon(
                                        Icons.remove_circle_outline),
                                    color: Colors.red,
                                    onPressed: () {
                                      //debugPrint(e['uid']);
                                      var collection = FirebaseFirestore
                                          .instance
                                          .collection('users');
                                      collection.doc(
                                          _friendsListProvider.currUser).update(
                                          {
                                            'friends': FieldValue.arrayRemove(
                                                [e.get('uid')]),
                                          });
                                      collection.doc(e.get('uid')).update({
                                        'friends':
                                        FieldValue.arrayRemove(
                                            [_friendsListProvider.currUser]),
                                      });
                                      _friendsListProvider.currUser.remove(
                                          e['uid']);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )).toList()
                );
              }
          );
    });
  }
}
