import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/feed_provider.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../services/firestore_service.dart';
import '../widgets/common_widgets/custom_app_bar.dart';
import 'create_post.dart';


class DailyActivity extends StatefulWidget {
  const DailyActivity({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<DailyActivity> {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final FeedProvider _feedProvider =
  Provider.of<FeedProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Create Daily Activity Post",
        needBackArrow: true,
      ),
      body: Column(
        children: [
          Form(
            key: _feedProvider.formKeyDaily,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:  const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Song',
                    ),
                    controller: _feedProvider.songTextEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid submission';
                      }
                    },
                  ),
                ),
                Padding(
                  padding:  const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Artist',
                    ),
                    controller: _feedProvider.artistTextEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid submission';
                      }
                    },
                  ),
                ),

                Padding(
                  padding:  const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 16),
                  child: ElevatedButton (
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.green
                    ),
                    onPressed: () {
                      if(_feedProvider.formKeyDaily.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        _feedProvider.createDailyPost();
                      }
                    },
                    child: Text(
                      'Share',
                      style: AppTextStyles.button(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}