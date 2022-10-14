import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/screens/add_friends_screen.dart';
import 'package:harmony_app/screens/profile_friends_screens.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

var currUser;
var friendsList;

//this screen displays the friends list from the current user.
//it uses a stream builder to query the information from firestore
//it displays the informations in Cards

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(''
            'Harmony',
            style: AppTextStyles.appBar(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                debugPrint('search for other users');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFriendsScreen()));
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                debugPrint('refresh button - friends list');
                setState(() {}); //refresh this page to show any changes
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: friendsListView()),
          ),
          Consumer<AuthProvider> (
            builder: (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
            debugPrint(myAuthProvider.currentUserModel.toString());
            currUser = (myAuthProvider.currentUserModel?.uid);
            friendsList = (myAuthProvider.currentUserModel?.friends);
            debugPrint('friends:');
            debugPrint(myAuthProvider.currentUserModel?.friends.toString());
          return const Text("");
          },
          ),
        ],
      ),
    );
  }
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where("uid", whereIn: friendsList).snapshots(),
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
                              onPressed: (){
                                debugPrint('take to friends profile');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => friends_profile_screen(name: e['firstName'],)));
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
                                  onPressed: () {},
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
