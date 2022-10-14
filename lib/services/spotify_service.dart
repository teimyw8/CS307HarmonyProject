import 'package:spotify_sdk/spotify_sdk.dart';


class SpotifyService {
  static String clientID = "f56caa5c620045cc8a7269bf1c718c12";

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

  static desyncSpotify () async {
    return await SpotifySdk.disconnect();
  }

}

