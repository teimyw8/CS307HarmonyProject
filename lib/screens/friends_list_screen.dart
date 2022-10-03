import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class friends_list_page extends StatefulWidget {
  const friends_list_page({Key? key}) : super(key: key);

  @override
  _friends_list_pageState createState() => _friends_list_pageState();
}

class _friends_list_pageState extends State<friends_list_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Friends List'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {},
              child: Text('Search for friends'),
              style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromWidth(100))),
        ));
  }
}
