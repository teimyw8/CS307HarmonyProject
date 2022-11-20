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

class TopItemList extends StatelessWidget {
  final double fontSize;
  final String title;
  final String item1;
  final String item2;
  final String item3;

  TopItemList({
    Key? key,
    this.fontSize = 10.0,
    this.title = "title",
    this.item1 = "item 1",
    this.item2 = "item 2",
    this.item3 = "item 3",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        //Title
        Padding(
          padding:
          const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Container(
            height: 30,
            width: 400,
            color: const Color(0xDCDCDCCD),
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize + 5,
              ),
            ),
          ),
        ),

        //Item 1
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            height: 30,
            width: 400,
            color: const Color(0xDCDCDCCD),
            child: Text(
              item1,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
        ),

        //Item 2
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            height: 30,
            width: 400,
            color: const Color(0xDCDCDCCD),
            child: Text(
              item2,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
        ),

        //Item 3
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            height: 30,
            width: 400,
            color: const Color(0xDCDCDCCD),
            child: Text(
              item3,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ],
    );


    /*
    return Container(
      color: const Color(0xDCDCDCCD),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: [

          //Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize + 5,
              ),
            ),
          ),

          //Item 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              item1,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),

          //Item 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              item2,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),

          //Item 3
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              item3,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
    */
  }
}
