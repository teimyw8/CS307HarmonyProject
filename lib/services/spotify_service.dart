import 'dart:convert';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;


class SpotifyService {
  static String clientID = "6b78e7c5dd5743a99d575b0f474efcca";
  static String clientSecret = "743ba6e4aefd494fbcd94e7088086610";

  static Future<bool> syncSpotify() async{

    try {
      bool apiReturn = await SpotifySdk.connectToSpotifyRemote(clientId: clientID, redirectUrl: 'http://localhost:8080');
      return apiReturn;
    } catch ( e){
      return false;
    }

    // var accessToken = await SpotifySdk.getAccessToken(clientId: clientId, redirectUrl: redirectUrl)


  }

  static desyncSpotify () async {
    return await SpotifySdk.disconnect();
  }

}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
  String getName(){
    return title;
  }
}