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

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);
  String? dropdownvalue;
  var items = [
    'no one',
    'only my friends',
    'everyone',
  ];

  @override
  Widget build(BuildContext context) {
    dropdownvalue = _editProfileProvider.getDisplayProfileTo();
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
                height: 30.h,
              ),
              Wrap(
                children: [
                  Text('The people who can see my profile are:',
                      //softWrap: false,
                      //maxLines: 1,
                      //overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textField()
                          .copyWith(fontSize: 18.sp, color: AppColors.black)),
                  DropdownButton(
                      value: _editProfileProvider.getDisplayProfileTo(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
