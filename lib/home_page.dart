import 'package:flutter/material.dart';
import 'package:harmony_app/editprofile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const EditProfile();
              },
            ),
          );
        },
        child: const Text('Profile'),
      ),
    );
  }
}
