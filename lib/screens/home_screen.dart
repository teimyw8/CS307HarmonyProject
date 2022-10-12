import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider _authProvider =
  Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(

        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              body: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(horizontal: 60.w, vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Home Page",
                        style: AppTextStyles.largeTitle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
