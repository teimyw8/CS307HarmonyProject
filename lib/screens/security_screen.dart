import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/helpers/security_constants.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../helpers/colors.dart';
import '../providers/edit_profile_provider.dart';
import 'friends_list_screen.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);
  String? dropDownValProfilePage;
  String? dropDownValName;

  @override
  Widget build(BuildContext context) {
    dropDownValProfilePage = _editProfileProvider.getDisplayProfileTo();
    dropDownValName = _editProfileProvider.getDisplayName();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Security Settings',
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
                    builder: (context) => (const FriendsListScreen())));
          },
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: [
                    Text('The people who can see my profile are:',
                        //softWrap: false,
                        //maxLines: 1,
                        //overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textField()
                            .copyWith(fontSize: 18.sp, color: AppColors.black)),
                    DropdownButton(
                        value: dropDownValProfilePage,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: SecurityConstants.PROFILEPAGESETTINGS.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                                style: AppTextStyles.textField().copyWith(
                                    fontSize: 18.sp, color: AppColors.black)),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropDownValProfilePage = value!;
                          });
                          _editProfileProvider.updateDisplayProfileTo(value);
                        })
                  ],
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: [
                    Text('People will see my profile with:',
                        //softWrap: false,
                        //maxLines: 1,
                        //overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textField()
                            .copyWith(fontSize: 18.sp, color: AppColors.black)),
                    DropdownButton(
                        value: dropDownValName,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: SecurityConstants.NAMESETTINGS.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                                style: AppTextStyles.textField().copyWith(
                                    fontSize: 18.sp, color: AppColors.black)),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropDownValName = value!;
                          });
                          _editProfileProvider.updateDisplayName(value);
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
