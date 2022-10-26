import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/field_validators.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/services/spotify_service.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../widgets/common_widgets/custom_app_loader.dart';
import '../providers/auth_provider.dart';
import 'friends_list_screen.dart';

class UserAnalyticsScreen extends StatefulWidget {
  const UserAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
}

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {
  final EditProfileProvider _editProfileProvider =
  Provider.of<EditProfileProvider>(Get.context!, listen: false);
  UserModel? temp;

  String _syncState = '';
  String _errorMessage = '';





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
                  title: "Analytics",
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
                              /* Title */
                              Container(
                                height: 40,
                                width: 300,
                                child:  const Text("Top Songs",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,

                                    ),
                                ),

                              ),
                              /* Song 1 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),

                                child:  const Text("Dummy Song 1",
                                  style: TextStyle(
                                  ),
                                ),

                              ),
                              /* Song 2 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),
                                child:  const Text("Dummy Song 2",
                                  style: TextStyle(


                                  ),
                                ),

                              ),
                              /* Song 3 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),
                                child:  const Text("Dummy Song 3",
                                  style: TextStyle(


                                  ),
                                ),

                              ),
                              /* Title */
                              Container(
                                height: 40,
                                width: 300,
                                child:  const Text("Top Artists",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,

                                  ),
                                ),

                              ),
                              /* Song 1 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),

                                child:  const Text("Dummy Artist 1",
                                  style: TextStyle(
                                  ),
                                ),

                              ),
                              /* Song 2 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),
                                child:  const Text("Dummy Artist 2",
                                  style: TextStyle(


                                  ),
                                ),

                              ),
                              /* Song 3 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),
                                child:  const Text("Dummy Artist 3",
                                  style: TextStyle(


                                  ),
                                ),

                              ),
                              Container(
                                height: 40,
                                width: 300,
                                child:  const Text("Top Genres",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,

                                  ),
                                ),


                              ),
                              /* Song 1 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),

                                child:  const Text("Dummy Genre 1",
                                  style: TextStyle(
                                  ),
                                ),

                              ),
                              /* Song 2 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),
                                child:  const Text("Dummy Genre 2",
                                  style: TextStyle(


                                  ),
                                ),

                              ),
                              /* Song 3 */
                              Container(
                                height: 40,
                                width: 300,
                                color: const Color(0xFFb5b5b5),
                                child:  const Text("Dummy Genre 3",
                                  style: TextStyle(


                                  ),
                                ),

                              ),
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
