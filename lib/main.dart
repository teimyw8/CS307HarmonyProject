import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/login_screen.dart';
import 'package:harmony_app/services/auth_service.dart';
import 'package:harmony_app/services/spotify_service.dart';
import 'package:provider/provider.dart';

///this function sets up the Service variables instances
void setupLocator() {
  GetIt.instance.registerLazySingleton(() => AuthService());
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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Settings'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String synced = "Sync";
  String name = '';


  void _sync() async {
    bool connected = await SpotifyService.syncSpotify();
    if(connected) {
      setState(() {
        synced = "Desync";
        name = '';
      });
    } else {
      setState(() {
        name = 'Sync failed, please make sure you are signed\n into spotify and try again';
      });

    }
  }

  void _deSync() async {
    bool disconnected = await SpotifyService.desyncSpotify();
    if(disconnected) {
      setState(() {
        synced = "Sync";
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:Column (
          children :  <Widget>[
             ElevatedButton(
               onPressed: () {
                 if(synced == "Sync"){
                   _sync();
                 } else {
                   _deSync();
                 }
               },
              child: Text(synced),
              ),
            Text(name),

          ],
        ),

      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

