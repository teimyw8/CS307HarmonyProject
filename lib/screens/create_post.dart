import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:harmony_app/widgets/common_widgets/custom_text_field.dart';
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
      resizeToAvoidBottomInset: false,
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
                        print(image);
                        print(album);
                        print(artist);
                        print("eeqwr");
                        _feedProvider.createPost(option, image, album, artist, 10.0);
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
                        return Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: snapshot.data!,
                          ),
                        );
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
      List<TopArtistModel> list = await  SpotifyService.searchArtist(query);
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    if (list[index].image.isNotEmpty)
                      CircleAvatar(
                        radius: 20,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(list[index].image[0]['url']),
                        ),
                      ),

                    if (list[index].image.isEmpty)
                      CircleAvatar(
                        radius: 20,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage("https://i.scdn.co/image/ab67616d00001e0299760923cfbfe739fb870817"),
                        ),
                      ),

                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        child: Text(
                            list[index].name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        onTap: () {
                          image = list[index].image[0]['url'];
                          _feedProvider.spotifyTextEditingController.text = list[index].name;
                        }
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
                onTap: () {
                  image = list[index].image[0]['url'];
                  _feedProvider.spotifyTextEditingController.text = list[index].name;
                },
              )
            );
          }
      );

    } else if (option == "Song" && query.isNotEmpty) {

      List<TopSongModel> list = await  SpotifyService.searchSong(query);

      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return Card(
                child: InkWell(
                  child: Row(
                    children: [
                      const SizedBox(width: 15),

                      if (list[index].image.isNotEmpty)
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(list[index].image),
                          ),
                        ),

                      if (list[index].image.isEmpty)
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage("https://i.scdn.co/image/ab67616d00001e0299760923cfbfe739fb870817"),
                          ),
                        ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: InkWell(
                            child: Text(
                                list[index].name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                            ),
                            onTap: () {
                              image = list[index].image;
                              _feedProvider.spotifyTextEditingController.text = list[index].name;
                              artist = list[index].artist;
                            }
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                  onTap: () {
                    image = list[index].image;
                    _feedProvider.spotifyTextEditingController.text = list[index].name;
                    artist = list[index].artist;
                  },
                )
            );
          }
      );

    } else if (option == "Album" && query.isNotEmpty) {

      List<AlbumModel> list = await  SpotifyService.searchAlbum(query);
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return Card(
                child: InkWell(
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      if (list[index].image.isNotEmpty)
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(list[index].image[0]['url']),
                          ),
                        ),

                      if (list[index].image.isEmpty)
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage("https://i.scdn.co/image/ab67616d00001e0299760923cfbfe739fb870817"),
                          ),
                        ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: InkWell(
                            child: Text(
                                list[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            onTap: () {
                              image = list[index].image[0]['url'];
                              _feedProvider.spotifyTextEditingController.text = list[index].name;
                              artist = list[index].artist;
                            }
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                  onTap: () {
                    image = list[index].image[0]['url'];
                    _feedProvider.spotifyTextEditingController.text = list[index].name;
                    print(list[index].artist);
                    artist = list[index].artist;
                  },
                )
            );
          }
      );

    } else if (option == "Playlist" && query.isNotEmpty) {

      List<PlaylistModel> list = await  SpotifyService.searchPlaylist(query);

      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return Card(
                child: InkWell(
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      if (list[index].image.isNotEmpty)
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(list[index].image[0]['url']),
                          ),
                        ),

                      if (list[index].image.isEmpty)
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage("https://i.scdn.co/image/ab67616d00001e0299760923cfbfe739fb870817"),
                          ),
                        ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: InkWell(
                            child: Expanded(
                              child: Text(
                                  list[index].name,
                                  overflow: TextOverflow.ellipsis,
                                maxLines: 1,

                              ),
                            ),
                            onTap: () {
                              image = list[index].image[0]['url'];
                              _feedProvider.spotifyTextEditingController.text = list[index].name;
                            }
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                  onTap: () {
                    image = list[index].image[0]['url'];
                    _feedProvider.spotifyTextEditingController.text = list[index].name;
                  },
                )
            );
          }
      );

    } else {
      return SizedBox.shrink();
    }
  }

}
