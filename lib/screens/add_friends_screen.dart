import 'package:flutter/material.dart';
import 'package:harmony_app/widgets/add_friends_widgets/user_tile_widget.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/custom_text_field.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({Key? key}) : super(key: key);

  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Add Friends",
          needBackArrow: true,
        ),
        body: Column(
          children: [
            CustomTextField(
              prefixIcon: Icon(Icons.search),
            ),
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return SearchUserTileWidget(
                  lastName: '',
                  firstName: '',
                  imageURL: '',
                  uid: '',
                );
              },
            )
          ],
        ));
  }
}
