import 'package:spotify_sdk/models/player_state.dart';
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

  static Future<bool> getPlayerState() async {
    PlayerState? test = await SpotifySdk.getPlayerState();
    return test!.isPaused;

  }

  static desyncSpotify () async {
    return await SpotifySdk.disconnect();
  }

}

