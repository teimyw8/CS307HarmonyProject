import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String? dropdownvalue;
  String? dropdownvalue1;
  var items = [
    'no one',
    'only my friends',
    'everyone',
  ];
  var items1 = [
    'my real name',
    'my username',
  ];

  @override
  Widget build(BuildContext context) {
    dropdownvalue = _editProfileProvider.getDisplayProfileTo();
    dropdownvalue1 = _editProfileProvider.getDisplayName();
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
                    builder: (context) => (const FriendsListPage())));
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
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                                style: AppTextStyles.textField().copyWith(
                                    fontSize: 18.sp, color: AppColors.black)),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue = value!;
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
                        value: dropdownvalue1,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items1.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                                style: AppTextStyles.textField().copyWith(
                                    fontSize: 18.sp, color: AppColors.black)),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue1 = value!;
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
