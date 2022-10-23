import 'package:flutter/material.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';

import 'friends_list_screen.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Security Settings',
          needBackArrow: true,
          needAvatar: true,
          needSettings: false,
          needHome: true,
          onHomeClicked: () {
            debugPrint(
                'Temporary, must be deleted when we finalize the home page');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (const FriendsListPage())));
          },
        ),
      ),
    );
  }
}
