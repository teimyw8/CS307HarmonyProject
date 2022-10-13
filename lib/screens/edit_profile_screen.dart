import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import 'friends_list_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(alignment: AlignmentDirectional.topStart, children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "Profile",
            needBackArrow: true,
            needAvatar: true,
            needSettings: false,
            needHome: true,
            onHomeClicked: () {
              debugPrint(
                  'Temporary, must be deleted when we finalize the home page');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (FriendsListPage())));
            },
          ),
          backgroundColor: AppColors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _editProfileProvider.swapEditingMode();
              setState(() {});
            },
            child: const Icon(Icons.edit),
          ),
          body: Stack(
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Username',
                    ),
                    initialValue: _editProfileProvider.getUserEmail(),
                    onSaved: (String? value) {},
                    enabled: _editProfileProvider.isEditing,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'First Name',
                    ),
                    initialValue: _editProfileProvider.getUserFirst(),
                    onSaved: (String? value) {},
                    enabled: _editProfileProvider.isEditing,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                    initialValue: _editProfileProvider.getUserLast(),
                    onSaved: (String? value) {},
                    enabled: _editProfileProvider.isEditing,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Username',
                    ),
                    initialValue: _editProfileProvider.getUserName(),
                    onSaved: (String? value) {},
                    enabled: _editProfileProvider.isEditing,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
