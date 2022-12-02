import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
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
  final double height;
  final double width;
  final int syncState;

  final bool iconBool;

  final String title;
  final String item1;
  final String item2;
  final String item3;

  final String image1;
  final String image2;
  final String image3;

  final String artist1;
  final String artist2;
  final String artist3;

  TopItemList({
    Key? key,
    this.fontSize = 10.0,
    this.title = "title",
    this.item1 = "item 1",
    this.item2 = "item 2",
    this.item3 = "item 3",
    this.height = 30,
    this.width = 400,
    this.iconBool = false,
    this.syncState = 1,
    this.image1 = "",
    this.image2 = "",
    this.image3 = "",
    this.artist1 = "",
    this.artist2 = "",
    this.artist3 = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (syncState == 0) {
      return Container();
    }
    if (syncState == 2) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(
          "Spotify must be synced to see analytics",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    if (iconBool) {

      return Column(
        children: [
          //Title
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Container(
              height: height - 10,
              width: width,
              //color: const Color(0xFF606266),
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: fontSize + 5,
                ),
              ),
            ),
          ),

          //Item 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
                height: height,
                width: width,
                color: const Color(0xDCDCDCCD),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5)),
                    CachedNetworkImage(
                      errorWidget: (context, url, error) => new Icon(Icons.download),
                      height: height,
                      imageUrl: image1
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5)),
                    Expanded(
                      child: Text(
                        item1 + artist1,
                        style: TextStyle(
                          fontSize: fontSize,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 5,
          ),


          //Item 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
                height: height,
                width: width,
                color: const Color(0xDCDCDCCD),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5)),
                    CachedNetworkImage(
                        errorWidget: (context, url, error) => new Icon(Icons.download),
                        height: height,
                        imageUrl: image2
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5)),
                    Expanded(
                      child: Text(
                        item2 + artist2,
                        style: TextStyle(
                          fontSize: fontSize,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 5,
          ),

          //Item 3
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
                height: height,
                width: width,
                color: const Color(0xDCDCDCCD),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5)),
                    CachedNetworkImage(
                        errorWidget: (context, url, error) => new Icon(Icons.download),
                        height: height,
                        imageUrl: image3
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5)),
                    Expanded(
                      child: Text(
                        item3 + artist3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          //Title
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Container(
              height: height,
              width: width,
              //color: const Color(0xFF606266),
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: fontSize + 5,
                ),
              ),
            ),
          ),

          //Item 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
                height: height,
                width: width,
                color: const Color(0xDCDCDCCD),
                child: Text(
                  item1,
                  style: TextStyle(
                    fontSize: fontSize,
                    overflow: TextOverflow.clip,
                  ),
                )),
          ),
          const SizedBox(
            height: 5,
          ),

          //Item 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
              height: height,
              width: width,
              color: const Color(0xDCDCDCCD),
              child: Expanded(
                child: Text(
                  item2,
                  style: TextStyle(
                    fontSize: fontSize,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),

          //Item 3
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
              height: height,
              width: width,
              color: const Color(0xDCDCDCCD),
              child: Expanded(
                child: Text(
                  item3,
                  style: TextStyle(
                    fontSize: fontSize,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

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
