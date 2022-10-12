import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Profile",
          needBackArrow: true,
          needAvatar: true,
          needSettings: false,
        ),
        backgroundColor: AppColors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _editProfileProvider.swapEditingMode();
            //build(context);
            setState(() {});
            printInfo(
              info: 'Arrives here',
            );
          },
          child: const Icon(Icons.edit),
        ),
        body: Stack(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
    );
  }
}
