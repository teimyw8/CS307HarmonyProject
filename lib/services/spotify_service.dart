import 'dart:convert';
import 'dart:io';

import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:harmony_app/models/top_model.dart';
import 'package:http/http.dart' as http;
import 'package:harmony_app/services/path_service.dart';



class SpotifyService {
  static String clientID = "f56caa5c620045cc8a7269bf1c718c12";
  final base64Credential =
  utf8.fuse(base64).encode('f56caa5c620045cc8a7269bf1c718c12:b7c7e8bbca224b49b13bc525fde22613');
  static String secret = '';

  static Future<String> syncSpotify() async{

    String userToken = '';
    try {
      bool apiReturn = await SpotifySdk.connectToSpotifyRemote(clientId: clientID, redirectUrl: 'http://localhost:8080');
      String userToken = await SpotifySdk.getAccessToken(clientId: clientID, redirectUrl: 'http://localhost:8080');


      return userToken;
    } catch ( e){
      return userToken;
    }


  }

  static Future<bool> getPlayerState() async {
    PlayerState? test = await SpotifySdk.getPlayerState();
    return test!.isPaused;

  }
  static Future<List<TopArtistModel>> getTopArtists() async{
    secret = await SpotifySdk.getAccessToken(clientId: clientID, redirectUrl: 'http://localhost:8080', scope: "user-top-read");

    final test = await http.get(Uri.parse(PathService.requestAuthorization(clientID, 'http://localhost:8080','good12')));


    final response = await http.get(Uri.parse('https://api.spotify.com/v1/me/top/artists'),
        headers: {'Authorization': 'Bearer $secret'}
    );

    List testList = jsonDecode(response.body)['items'];
    List<TopArtistModel> artistList = testList.map( (i) => TopArtistModel.fromJson(i)).toList();

    return artistList;


  }

  static Future<List<TopSongModel>> getTopSongs() async{
    final test = await http.get(Uri.parse(PathService.requestAuthorization(clientID, 'http://localhost:8080','good12')));


    final response = await http.get(Uri.parse('https://api.spotify.com/v1/me/top/tracks'),
        headers: {'Authorization': 'Bearer $secret'}
    );

    List testList = jsonDecode(response.body)['items'];
    List<TopSongModel> artistList = testList.map( (i) => TopSongModel.fromJson(i)).toList();
    return artistList;

  }
  static getTopGenres(){

  }

  static desyncSpotify () async {
    return await SpotifySdk.disconnect();
  }

}

