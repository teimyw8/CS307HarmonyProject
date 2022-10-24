import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../widgets/common_widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider _authProvider =
  Provider.of<AuthProvider>(Get.context!, listen: false);

  feed() {
    Container(
      child: Text('data'),
    );
  }

  Future<Null> refresh() async {
    await getFeed();

    setState(() {});

    return;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Scaffold(
            appBar: CustomAppBar(
              title: "Harmony",
              needBackArrow: false,
              needAvatar: true,
              needSettings: true,
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
            body: RefreshIndicator(
              child: feed(),
              onRefresh: refresh,
            ),
          ),
        ],
      ),
    );
  }

  getFeed() async {


  }
}
