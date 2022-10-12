import 'package:flutter/material.dart';
import 'package:firestore_search/firestore_search.dart';
import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import 'home_screen.dart';

class add_friends extends StatefulWidget {
  const add_friends({Key? key}) : super(key: key);

  @override
  _add_friendsState createState() => _add_friendsState();
}

class _add_friendsState extends State<add_friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(
          'Harmony',
          style: AppTextStyles.appBar(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                debugPrint('return to home');
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => (HomeScreen())));
              },
              icon: Icon(Icons.home)),
          IconButton(
              onPressed: () {
                debugPrint('refresh button - friends list');
                setState(() {}); //refresh this page to show any changes
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                child: const Icon(
                    Icons.person_add,
                    size: 50,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                child: const Text(
                  'Add Friends',
                  //style: AppTextStyles.headline(), //change to this later
                  style: TextStyle(fontSize: 50, fontFamily: 'Inter', fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
