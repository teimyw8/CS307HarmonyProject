import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/screens/edit_profile_screen.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../screens/profile_screen.dart';

class SharedSongList extends StatelessWidget {

  final int count;




  SharedSongList({
    Key? key,
    this.count = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) =>
          Card(child: ListTile(title: Text("$index"))),
    );
  }
}
