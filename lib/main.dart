import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/welcome_screen.dart';
import 'package:harmony_app/services/auth_service.dart';
import 'package:provider/provider.dart';

///this function sets up the Service variables instances
void setupLocator() {
  GetIt.instance.registerLazySingleton(() => AuthService());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!);
          },
          debugShowCheckedModeBanner: false,
          title: 'Harmony',
          initialRoute: '/',
          routes: {
            '/': (context) => const WelcomeScreen(),
          },
        );
      },
    );
  }
}
