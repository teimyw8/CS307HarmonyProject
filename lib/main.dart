import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/add_friends_provider.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:harmony_app/providers/friend_screen_provider.dart';
import 'package:harmony_app/providers/friends_list_provider.dart';
import 'package:harmony_app/providers/feed_provider.dart';
import 'package:harmony_app/screens/login_screen.dart';
import 'package:harmony_app/services/auth_service.dart';
import 'package:harmony_app/services/chat_service.dart';
import 'package:harmony_app/services/feed_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

import 'providers/friend_requests_provider.dart';


//TODO for chats. When deleting one chat, the UserModel for the remaining chat gets set to that user model of the deleted chat
///this function sets up the Service variables instances
void setupLocator() {
  GetIt.instance.registerLazySingleton(() => AuthService());
  GetIt.instance.registerLazySingleton(() => FirestoreService());
  GetIt.instance.registerLazySingleton(() => ChatService());
  GetIt.instance.registerLazySingleton(() => FeedService());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => EditProfileProvider()),
      ChangeNotifierProvider(create: (_) => AddFriendsProvider()),
      ChangeNotifierProvider(create: (_) => FriendRequestsProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(create: (_) => FriendsListProvider()),
      ChangeNotifierProvider(create: (_) => FeedProvider()),
      ChangeNotifierProvider(create: (_) => FriendScreenProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!);
          },
          debugShowCheckedModeBanner: false,
          title: 'Harmony',
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}
