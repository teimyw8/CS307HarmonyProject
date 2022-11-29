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
import 'package:harmony_app/services/spotify_service.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../services/firestore_service.dart';
import '../widgets/Songs_widgets/SearchSongTileWidget.dart';
import '../widgets/common_widgets/custom_app_bar.dart';
import '../widgets/common_widgets/custom_text_field.dart';
import 'create_post.dart';
import 'home_screen.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final FeedProvider _feedProvider =
      Provider.of<FeedProvider>(Get.context!, listen: false);
  //final SpotifyService _spotifyService = GetIt.instance<SpotifyService>();

  List<String> optionsSpotify = <String>['Song', 'Artist', 'Album', 'Playlist'];
  late String option = optionsSpotify.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Create post",
        needBackArrow: true,
      ),
      body: Column(
        children: [
          Form(
            key: _feedProvider.formKeyPosts,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///in a single post they can either, share a song, an album, an artist or a playlist.
                /// and the can always acompany it with a text
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppColors.green),
                    onPressed: () {
                      if (_feedProvider.formKeyPosts.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        _feedProvider.createPost();
                        _feedProvider.spotifyTextEditingController.clear();
                        _feedProvider.textEditingController?.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }
                    },
                    child: Text(
                      'Submit',
                      style: AppTextStyles.button(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: CustomTextField(
                    hintText: "Description",
                    controller: _feedProvider.textEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid submission';
                      }
                    },
                  ),
                ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 10.w,),
                        Expanded(
                          child: CustomTextField(
                            hintText: "Song/Artist/Album",
                            controller: _feedProvider.spotifyTextEditingController,
                            onChanged: (value) {
                              //setState(() {});
                            },
                          ),
                        ),
                        //Spacer(),
                        DropdownButton<String>(
                            value: option,
                            items: optionsSpotify.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged:  (String? value) {
                              // This is called when the user selects an item.
                              print(value);
                              setState(() {
                                option = value!;
                              });
                            },
                        ),
                        SizedBox(width: 10.w,),
                      ],),
                if (_feedProvider.spotifyTextEditingController.text.trim().isNotEmpty)
                  StreamBuilder(
                      stream: _firestoreService.firebaseFirestore
                          .collection('users').snapshots(),

                      builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) // TODO: show alert
                          return Text('Something went wrong');

                          var len = snapshot.data?.docs.length ?? 0;
                          if (len == 0) {
                            return Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("No users found",
                                  style: TextStyle(
                                  fontSize: 20, color: Colors.grey))
                                ],
                            ),
                          );
                          }

                          return Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return SearchSongWidgetTile(

                                    );
                                  }
                              ),
                          );
                      }
                  )
              ],),
          ),
        ],
      ),
    );
  }
}
