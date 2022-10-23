import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/field_validators.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/screens/security_page.dart';
import 'package:harmony_app/services/spotify_service.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../widgets/common_widgets/custom_app_loader.dart';
import 'friends_list_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);
  UserModel? temp;

  String _syncState = '';
  String _errorMessage = '';

  _sync() async {
    String connected = await SpotifyService.syncSpotify();

    if (connected != '') {
      bool paused = await SpotifyService.getPlayerState();
      setState(() {
        _syncState = "Desync";
        if (paused) {
          _errorMessage = 'Paused';
        } else {
          _errorMessage = 'Playing';
        }
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_editProfileProvider.currentUserModel!.uid)
          .update({'spotifyToken': connected});
    } else {
      setState(() {
        _errorMessage =
            'Sync failed, please make sure you are signed\n into spotify and try again';
      });
    }
  }

  _desync() async {
    bool disconnected = await SpotifyService.desyncSpotify();
    if (disconnected) {
      setState(() {
        _syncState = "Sync with Spotify";
        _errorMessage = '';
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(_editProfileProvider.currentUserModel!.uid)
          .update({'spotifyToken': ''});
    }
  }

  _pressedInEdit() {
    setState(() {
      _errorMessage =
          'Please exit editing mode before attempting\n to sync/desync with Spotify';
    });
  }

  _test() {
    print("");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AuthProvider _authProvider =
        Provider.of<AuthProvider>(Get.context!, listen: false);
    String token = _authProvider.currentUserModel!.spotifyToken;
    setState(() {
      if (token == '') {
        _syncState = 'Sync with Spotify';
      } else {
        _syncState = 'Desync';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (FriendsListPage())));
                  },
                ),
                backgroundColor: AppColors.white,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    temp = UserModel.fromJson(
                        _editProfileProvider.currentUserModel!.toJson());
                    _editProfileProvider.update(temp!);
                    if (!_editProfileProvider.isEditing) {
                      setState(() {});
                    }
                  },
                  child: (_editProfileProvider.isEditing)
                      ? const Icon(Icons.save)
                      : const Icon(Icons.edit),
                ),
                body: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _editProfileProvider.formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Email',
                                  ),
                                  initialValue:
                                      _editProfileProvider.getUserEmail(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: FieldValidator.validateEmail,
                                  onSaved: (String? value) {
                                    value ??= "";
                                    temp!.email = value;
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
                                    labelText: 'First Name',
                                  ),
                                  initialValue:
                                      _editProfileProvider.getUserFirst(),
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
                                  initialValue:
                                      _editProfileProvider.getUserLast(),
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
                                  initialValue:
                                      _editProfileProvider.getUserName(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: FieldValidator.validateUserName,
                                  onSaved: (String? value) {
                                    value ??= "";
                                    temp!.username = value;
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
                                    hintText: '(Optional)',
                                    labelText: 'Bio',
                                  ),
                                  maxLines: 4,
                                  initialValue: _editProfileProvider.getBio(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: FieldValidator.validateBio,
                                  onSaved: (String? value) {
                                    value ??= "";
                                    temp!.bio = value;
                                  },
                                  enabled: _editProfileProvider.isEditing,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      myAuthProvider
                                          .onForgotPasswordTextClicked();
                                    },
                                    child: Text(
                                      "Forgot password?",
                                      style: AppTextStyles.subNote(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(29, 185, 84, 1.0)),
                                onPressed: () {
                                  if (!_editProfileProvider.isEditing) {
                                    if (_syncState == "Sync with Spotify") {
                                      _sync();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                              'Confirm desyncing your Spotify account'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _desync();
                                                Navigator.pop(
                                                    context, 'Confirm');
                                              },
                                              child: const Text('Confirm'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    _pressedInEdit();
                                  }
                                },
                                child: Text(_syncState),
                              ),
                              Text(_errorMessage),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          29, 185, 84, 1.0)),
                                  onPressed: () {
                                    if (!_editProfileProvider.isEditing) {
                                      Get.to(() => const SecurityPage());
                                    }
                                  },
                                  child: const Text('Go to Security Settings')),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
