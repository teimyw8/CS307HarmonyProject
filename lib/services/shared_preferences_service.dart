import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {


  ///this function gets info whether user is logged in
  Future<bool> getIsUserLoggedIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = _prefs.getBool("isLoggedIn") ?? false;
    return isLoggedIn;
  }

  ///this function gets info whether user is logged in
  Future<String> getUserUid() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String uid = _prefs.getString("uid") ?? "";
    return uid;
  }

  ///this function saves user info in shared preferences
  Future<void> logUserIn({required String uid}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("isLoggedIn", true);
    await _prefs.setString("uid", uid);
    return;
  }

  ///this function saves user info in shared preferences
  Future<void> logUserOut() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("isLoggedIn", false);
    await _prefs.setString("uid", "");
    return;
  }

}