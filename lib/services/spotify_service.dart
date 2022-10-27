import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:harmony_app/services/path_service.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:harmony_app/providers/auth_provider.dart';




class SpotifyService {
  static String clientID = "f56caa5c620045cc8a7269bf1c718c12";
  AuthProvider _authProvider =  Provider.of<AuthProvider>(Get.context!, listen: false);
  static Future<String> syncSpotify() async{

    String userToken = '';
    try {
      bool apiReturn = await SpotifySdk.connectToSpotifyRemote(clientId: clientID, redirectUrl: 'http://localhost:8080', scope: "user-read-playback-state");
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

  static void getTop() async {

    String secret = await SpotifySdk.getAccessToken(clientId: clientID, redirectUrl: 'http://localhost:8080');
    final base64Credential =
    utf8.fuse(base64).encode('f56caa5c620045cc8a7269bf1c718c12:b7c7e8bbca224b49b13bc525fde22613');
    final test = await http.get(Uri.parse(PathService.requestAuthorization(clientID, 'http://localhost:8080','good12')));

    print(test);
    /*
    final code = Uri.parse(test.toString()).queryParameters['code'];

    final response1 = await http.post(
      Uri.parse(PathService.requestToken),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': 'http://localhost:8080',
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );
*/
    final response = await http.get(Uri.parse('https://api.spotify.com/v1/me/player'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $secret'}
            );


    if(response.statusCode == 200){
      print("good");

    } else {
      print(response.body);

    }
  }

  static desyncSpotify () async {
    return await SpotifySdk.disconnect();
  }

}

