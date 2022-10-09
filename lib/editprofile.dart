import 'package:flutter/material.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';

import 'helpers/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        needBackArrow: true,
        needAvatar: true,
        needSettings: false,
      ),
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }
}
