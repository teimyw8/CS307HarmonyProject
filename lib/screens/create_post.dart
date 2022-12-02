import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/models/top_model.dart';
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
  String image = "";
  String album = "";
  String artist = "";
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
                        //we need to send to createPost() the following
                        //album,artist --> these are sent but not always have values
                        //we always send image and the option
                        _feedProvider.createPost(option, image, album, artist);
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
                            hintText: "Song/Artist/Album/Playlist",
                            controller: _feedProvider.spotifyTextEditingController,
                            onChanged: (value) {
                              setState(() {});
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
                (_feedProvider.spotifyTextEditingController.text.trim().isNotEmpty)
                  ? FutureBuilder <Widget>(
                    future: searchSpotifyResults(option, _feedProvider.spotifyTextEditingController.text.trim()),
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                    )
                    : const SizedBox.shrink()
              ],),
          ),
        ],
      ),
    );
  }

 Future<Widget> searchSpotifyResults(String option, String query) async{

    if (option == "Artist" && query.isNotEmpty) {
      print("before spotify call");
      List<TopArtistModel> list = await  SpotifyService.searchArtist(query);
      print("after spotify call");
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              child: Row(
                children: [
                  //Image(image: NetworkImage(list[index].image.toString()),),
                  InkWell(
                    child: Text(list[index].name),
                    onTap: () {
                      image = list[index].image.toString();
                      _feedProvider.spotifyTextEditingController.text = list[index].name;
                    }
                  ),
                  const SizedBox(height: 25),
                ],
              )
            );
          }
      );

    } else if (option == "Song" && query.isNotEmpty) {

      List<TopArtistModel> list = await  SpotifyService.searchArtist(query);

      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Card(
                child: Row(
                  children: [
                    //Image(image: NetworkImage(list[index].image.toString()),),
                    InkWell(
                        child: Text(list[index].name),
                        onTap: () {
                          //album = list[index].album;
                          //artist = list[index].artist;
                          image = list[index].image.toString();
                          _feedProvider.spotifyTextEditingController.text = list[index].name;
                        }
                    ),
                    const SizedBox(height: 25),
                  ],
                )
            );
          }
      );

    } else if (option == "Album" && query.isNotEmpty) {

      List<TopArtistModel> list = await  SpotifyService.searchArtist(query);

      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Card(
                child: Row(
                  children: [
                    //Image(image: NetworkImage(list[index].image.toString()),),
                    InkWell(
                        child: Text(list[index].name),
                        onTap: () {
                          //artist = list[index].artist;
                          image = list[index].image.toString();
                          _feedProvider.spotifyTextEditingController.text = list[index].name;
                        }
                    ),
                    const SizedBox(height: 25),
                  ],
                )
            );
          }
      );

    } else if (option == "Playlist" && query.isNotEmpty) {

      List<TopArtistModel> list = await  SpotifyService.searchArtist(query);

      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Card(
                child: Row(
                  children: [
                    //Image(image: NetworkImage(list[index].image.toString()),),
                    InkWell(
                        child: Text(list[index].name),
                        onTap: () {
                          image = list[index].image.toString();
                          _feedProvider.spotifyTextEditingController.text = list[index].name;
                        }
                    ),
                    const SizedBox(height: 25),
                  ],
                )
            );
          }
      );

    } else {
      return SizedBox.shrink();
    }
  }

}
