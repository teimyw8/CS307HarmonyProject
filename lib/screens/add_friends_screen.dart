import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/add_friends_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Friends",
        needBackArrow: true,
      ),
      body: Consumer<AddFriendsProvider>(
        builder: (BuildContext context, AddFriendsProvider myAddFriendsProvider,
            Widget? child) {
          return Column(children: [
            CustomTextField(
              prefixIcon: Icon(Icons.search),
              controller: myAddFriendsProvider.searchBarEditingController,
              onChanged: (value) {
                myAddFriendsProvider.onSearchQueryChanged();
              },
            ),
            if (myAddFriendsProvider.searchBarEditingController!.text.isNotEmpty) StreamBuilder(
              stream: _firestoreService.firebaseFirestore
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo:
                        myAddFriendsProvider.searchBarEditingController!.text,
                    isLessThan: myAddFriendsProvider
                            .searchBarEditingController!.text
                            .substring(
                                0,
                                myAddFriendsProvider.searchBarEditingController!
                                        .text.length -
                                    1) +
                        String.fromCharCode(myAddFriendsProvider
                                .searchBarEditingController!.text
                                .codeUnitAt(myAddFriendsProvider
                                        .searchBarEditingController!
                                        .text
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
                  return Column(
                    children: [Center(child: CustomAppLoader())],
                  );

                var len = snapshot.data!.docs.length;
                if (len == 0)
                  return Column(
                    children: [
                      SizedBox(height: 100),
                      Center(
                        child: Text("No users available",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                      )
                    ],
                  );

                List<UserModel> users = snapshot.data!.docs
                    .map((doc) =>
                        UserModel.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();

                print("users: $users");

                return Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Text(users[index].toString());
                      }),
                );
              },
            ),
          ]);
        },
      ),
    );
  }
}
