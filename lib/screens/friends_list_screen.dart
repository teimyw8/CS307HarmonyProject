import 'package:cloud_firestore/cloud_firestore.dart';
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
        actions: [
          IconButton(
              onPressed: () {
                debugPrint('refresh button - friends list');
                setState(() {}); //refresh this page to show any changes
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: <Widget>[friendsListView()],
      ),
    );
  }
}

class friendsListView extends StatefulWidget {
  const friendsListView({Key? key}) : super(key: key);

  @override
  _friendsListViewState createState() => _friendsListViewState();
}

class _friendsListViewState extends State<friendsListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Error, reload');
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ListView(
            shrinkWrap: true,
            children: documents
                .map((e) => Card(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(e['firstName']),
                          Spacer(),
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  color: Colors.green,
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList());
      },
    );
  }
}
