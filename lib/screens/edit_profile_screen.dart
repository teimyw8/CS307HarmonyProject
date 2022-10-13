import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../models/user_model.dart';
import 'friends_list_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);
  final formKey = GlobalKey<FormState>();
  UserModel? temp;

  String _syncState = 'test';

  _test() {
    print("");
  }

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
              if (!_editProfileProvider.isEditing) {
                temp = _editProfileProvider.currentUserModel;
                formKey.currentState!.save();
                _editProfileProvider
                    .setUserInfo(UserModel.fromJson(temp!.toJson()));
              }
              setState(() {});
            },
            child: (_editProfileProvider.isEditing) ? const Icon(Icons.save) : const Icon(Icons.edit),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First Name',
                        ),
                        initialValue: _editProfileProvider.getUserFirst(),
                        onSaved: (String? value) {
                          value ??= "";
                          temp!.firstName = value;
                        },
                        enabled: _editProfileProvider.isEditing,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                        initialValue: _editProfileProvider.getUserLast(),
                        onSaved: (String? value) {
                          value ??= "";
                          temp!.lastName = value;
                        },
                        enabled: _editProfileProvider.isEditing,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Username',
                        ),
                        initialValue: _editProfileProvider.getUserName(),
                        onSaved: (String? value) {
                          value ??= "";
                          if (_editProfileProvider.meetsUsernameReqs(value)) {
                            temp!.username = value;
                          } else {
                            PopUpDialog.showErrorPopUpDialog(
                                title: 'Username incorrect',
                                message:
                                    'Username must be between 5 and 15 characters (inclusive), only contain alphanumeric characters or ".", and be a unique username.',
                                confirmLabel: 'Close',
                                onCloseClick: _test);
                          }
                        },
                        enabled: _editProfileProvider.isEditing,
                      ),
                    ),
                    ElevatedButton(
                      onPressed:  () {

                      },
                      child: Text(_syncState),
                    ),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }
}
