import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/login_screen.dart';
import 'package:harmony_app/services/auth_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

///this function sets up the Service variables instances
void setupLocator() {
  GetIt.instance.registerLazySingleton(() => AuthService());
  GetIt.instance.registerLazySingleton(() => FirestoreService());
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider())
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
