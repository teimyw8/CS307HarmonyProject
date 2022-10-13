import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchUserTileWidget extends StatefulWidget {
  String imageURL;
  String firstName;
  String lastName;
  String uid;


  SearchUserTileWidget(
      {required this.imageURL, required this.firstName, required this.lastName, required this.uid});

  @override
  State<SearchUserTileWidget> createState() => _SearchUserTileWidgetState();
}

class _SearchUserTileWidgetState extends State<SearchUserTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: Row(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: "http://via.placeholder.com/350x150",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ],
          ),
          Icon(Icons.add, size: 20.h,)
        ],
      ),
    );
  }
}
