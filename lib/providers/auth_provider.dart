import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/service_constants.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/screens/home_screen.dart';
import 'package:harmony_app/screens/login_screen.dart';
import 'package:harmony_app/screens/profile_picture.dart';
import 'package:harmony_app/screens/sign_up_screen.dart';
import 'package:harmony_app/services/auth_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/services/shared_preferences_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import '../helpers/security_constants.dart';
import '../screens/forgot_password_screen.dart';

class AuthProvider with ChangeNotifier {
  UserModel? currentUserModel;

  AuthService get _authService => GetIt.instance<AuthService>();
  SharedPreferencesService get _sharedPreferencesService => GetIt.instance<SharedPreferencesService>();

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();

  //LoginScreen text editing controllers
  TextEditingController? loginEmailTextEditingController =
      TextEditingController();
  TextEditingController? loginPasswordTextEditingController =
      TextEditingController();

  //ForgotPasswordScreen text editing controllers
  TextEditingController? forgotPasswordEmailTextEditingController =
      TextEditingController();

  //SignUpScreen text editing controllers
  TextEditingController? signUpEmailTextEditingController =
      TextEditingController();
  TextEditingController? signUpPasswordTextEditingController =
      TextEditingController();
  TextEditingController? signUpReEnterPasswordTextEditingController =
      TextEditingController();
  TextEditingController? signUpFirstNameTextEditingController =
      TextEditingController();
  TextEditingController? signUpLastNameTextEditingController =
      TextEditingController();
  TextEditingController? signUpUsernameTextEditingController =
      TextEditingController();

  //this is a key used for Form inside LoginScreen()
  final loginKey = GlobalKey<FormState>();

  //this is a key used for Form inside SignUpScreen()
  final signUpKey = GlobalKey<FormState>();

  //this is a key used for Form inside ResetPasswordScreen()
  final resetPasswordKey = GlobalKey<FormState>();

  //this variable track if something on the screen is loading
  bool isLoading = false;

  ///this function is used to initialize variables for LoginScreen
  void initializeLoginScreenVariables() {
    loginPasswordTextEditingController = TextEditingController();
    loginEmailTextEditingController = TextEditingController();
    notifyListeners();
  }

  ///this function is used to dispose variables for LoginScreen
  void disposeLoginScreenVariables() {
    loginPasswordTextEditingController!.dispose();
    loginPasswordTextEditingController = null;
    loginEmailTextEditingController!.dispose();
    loginEmailTextEditingController = null;
    notifyListeners();
  }

  ///this function is used to initialize variables for SignUpScreen
  void initializeSignUpScreenVariables() {
    signUpEmailTextEditingController = TextEditingController();
    signUpPasswordTextEditingController = TextEditingController();
    signUpReEnterPasswordTextEditingController = TextEditingController();
    signUpFirstNameTextEditingController = TextEditingController();
    signUpLastNameTextEditingController = TextEditingController();
    signUpUsernameTextEditingController = TextEditingController();
    notifyListeners();
  }

  ///this function is used to dispose variables for SignUpScreen
  void disposeSignUpScreenVariables() {
    signUpEmailTextEditingController!.dispose();
    signUpEmailTextEditingController = null;
    signUpPasswordTextEditingController!.dispose();
    signUpPasswordTextEditingController = null;
    signUpReEnterPasswordTextEditingController!.dispose();
    signUpReEnterPasswordTextEditingController = null;
    signUpFirstNameTextEditingController!.dispose();
    signUpFirstNameTextEditingController = null;
    signUpLastNameTextEditingController!.dispose();
    signUpLastNameTextEditingController = null;
    signUpUsernameTextEditingController!.dispose();
    signUpUsernameTextEditingController = null;
    notifyListeners();
  }

  ///this function is used to initialize variables for ForgotPasswordScreen
  void initializeForgotPasswordScreenVariables() {
    forgotPasswordEmailTextEditingController = TextEditingController();
    notifyListeners();
  }

  ///this function is used to dispose variables for LoginScreen
  void disposeForgotPasswordScreenVariables() {
    forgotPasswordEmailTextEditingController!.dispose();
    forgotPasswordEmailTextEditingController = null;
    notifyListeners();
  }

  ///this function logs user in. If the login is successful, then they get redirected to HomeScreen. Else a pop up message
  ///with an appropriate error shows up.
  Future<void> loginUser() async {
    if (loginKey.currentState!.validate()) {
      startLoading();
      try {
        await _authService.loginUser(
            email: loginEmailTextEditingController!.text,
            password: loginPasswordTextEditingController!.text);
        var userDocData = await _firestoreService.retrieveUserFromFirestore(
            uid: _authService.firebaseAuth.currentUser!.uid);

        //getting device token
        await FirebaseMessaging.instance.requestPermission();
        FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
        String tokenId = await _firebaseMessaging.getToken() ?? "";
        await _firestoreService.updateTokenIdInFirestore(
            uid: _authService.firebaseAuth.currentUser!.uid,
            tokenId: tokenId
        );

        currentUserModel = UserModel.fromJson(userDocData!);
        await _sharedPreferencesService.logUserIn(uid: currentUserModel!.uid);
        goToHomeScreen();
      } on AuthException catch (e) {
        showErrorDialog(e.cause);
      } on FirestoreException catch (e) {
        showErrorDialog(e.cause);
      } catch (e) {
        showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
      }
      stopLoading();
    }
  }

  ///this function logs a user out
  Future<void> logOutUser() async {
    try {
      currentUserModel = null;
      _sharedPreferencesService.logUserOut();
      goToLoginScreen();
    } catch (e) {

    }
  }

  ///this function is triggered when the user clicks on Sign Up button on SignUpScreen
  Future<void> signUpUser() async {
    if (signUpKey.currentState!.validate()) {
      startLoading();
      try {
        //first need to check if this username already exists
        await _firestoreService.doesUsernameAlreadyExist(
          username: signUpUsernameTextEditingController!.text,
        );
        await _authService.signUpUser(
            email: signUpEmailTextEditingController!.text,
            password: signUpPasswordTextEditingController!.text);
        String uid = _authService.firebaseAuth.currentUser?.uid ?? "";
        if (uid != "") {
          //getting device token
          await FirebaseMessaging.instance.requestPermission();
          FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
          String tokenId = await _firebaseMessaging.getToken() ?? "";
          await _firestoreService.addUserToFirestore(
              uid: uid,
              chatNotifStatus: true,
              FRNotifStatus: true,
              email: signUpEmailTextEditingController!.text,
              firstName: signUpFirstNameTextEditingController!.text,
              lastName: signUpLastNameTextEditingController!.text,
              userName: signUpUsernameTextEditingController!.text,
              bio: "",
              displayProfileTo: SecurityConstants.ONLYFRIENDS,
              displayName: false,
              friends: [],
              password: signUpPasswordTextEditingController!.text,
              profilepic: "hello",
              tokenId: tokenId,
              dailyNotifStatus: true
          );

          var userDocData =
              await _firestoreService.retrieveUserFromFirestore(uid: uid);
          currentUserModel = UserModel.fromJson(userDocData!);
        }
        await _sharedPreferencesService.logUserIn(uid: currentUserModel!.uid);
        //we signed up user successfully and added the user to Firestore
        goToHomeScreen();
      } on AuthException catch (e) {
        showErrorDialog(e.cause);
      } on FirestoreException catch (e) {
        showErrorDialog(e.cause);
      } catch (e) {
        showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
      }
      stopLoading();
    }
  }

  ///this function is triggered when the user clicks on Reset button on ForgotPasswordScreen
  Future<void> onResetPasswordClicked() async {
    if (resetPasswordKey.currentState!.validate()) {
      startLoading();
      try {
        await _authService.forgotPassword(
            email: forgotPasswordEmailTextEditingController!.text);
        forgotPasswordEmailTextEditingController!.clear();
        PopUpDialog.showAcknowledgePopUpDialog(
            title: "Email Sent!",
            message:
                "Please check your inbox for instructions on how to reset your password",
            onOkClick: () {
              Get.close(1);
            });
      } on AuthException catch (e) {
        showErrorDialog(e.cause);
      } catch (e) {
        showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
      }
      stopLoading();
    }
  }

  ///this function is triggered when the user clicks on ForgotPassword text
  Future<void> onForgotPasswordTextClicked() async {
    Get.to(() => ForgotPasswordScreen());
  }

  Future<void> onProfilePic() async {
    Get.to(() => ProfilePictureScreen());
  }

  ///this function is triggered when the user clicks on SignUp text
  Future<void> onSignUpTextClicked() async {
    Get.to(() => SignUpScreen());
  }

  ///this function shows an error dialog
  void showErrorDialog(String message) {
    PopUpDialog.showAcknowledgePopUpDialog(
        title: "Error!",
        message: message,
        onOkClick: () {
          Get.close(1);
        });
  }

  ///these 2 functions start and stop loading logic for a screen
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  ///this function pops all the AuthScreens and navigates user to the HomeScreen
  void goToHomeScreen() async {
    Get.offAll(() => const HomeScreen());
  }

  ///this function pops all the Screens and navigates user to the LoginScreen
  void goToLoginScreen() async {
    Get.offAll(() => const LoginScreen());
  }

  Future<void> updateCurrentUser() async {
    String uid = _authService.firebaseAuth.currentUser?.uid ?? "";
    var userDocData =
    await _firestoreService.retrieveUserFromFirestore(uid: uid);
    currentUserModel =  UserModel.fromJson(userDocData!);
    notifyListeners ();
  }

  ///this function updates the current profile pic of a user
  void updateProfilePic(String newProfilePicURL) async {
    currentUserModel!.profilepic = newProfilePicURL;
    notifyListeners();
  }


  ///this function updates the current user model
  void setCurrentUserModel(UserModel newUserModel) async {
    currentUserModel = newUserModel;
    notifyListeners();
  }

  void swapDailyNotification(bool b) {
    _firestoreService.swapDailyNotification(currentUserModel!.uid,b);
  }

  void swapChatNotification(bool b) {
    _firestoreService.swapChatNotification(currentUserModel!.uid,b);
  }

  void swapFRNotification(bool b) {
    _firestoreService.swapFRNotification(currentUserModel!.uid,b);
  }
}
