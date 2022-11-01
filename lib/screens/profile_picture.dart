import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:harmony_app/providers/edit_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';



class ProfilePictureScreen extends StatefulWidget {
  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {

  final EditProfileProvider _editProfileProvider =
  Provider.of<EditProfileProvider>(Get.context!, listen: false);

  XFile? image;

  UserModel? temp;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    await Firebase.initializeApp(); //delete later
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
    var imageFile = File(image!.path);
    String fileName = Path.basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      var url = await ref.getDownloadURL();
      String image_url = url.toString();
      temp = _editProfileProvider.currentUserModel;
      _editProfileProvider.setProfilePic(temp!, image_url);
    }).catchError((onError) {
      print(onError);
    });



  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Picture'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text('Upload Photo'),
            ),
            SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            image != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CircleAvatar(
                  backgroundImage: Image.file(
                    File(image!.path),
                  ).image,
                  radius: 150,
                ),
              ),
            )
                : ProfilePicture(
              name: '',
              radius: 150,
              fontsize: 21,
              img: _editProfileProvider.getUserProfilePic(),
            ),

          ],
        ),
      ),
    );
  }
}
